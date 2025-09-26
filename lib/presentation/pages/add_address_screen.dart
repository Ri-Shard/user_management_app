import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/validators/validators.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/blocs/address/address_event.dart';
import 'package:user_management_app/presentation/blocs/address/address_state.dart';
import 'package:user_management_app/presentation/pages/home_screen.dart';
import 'package:user_management_app/presentation/widgets/custom_button.dart';
import 'package:user_management_app/presentation/widgets/custom_text_field.dart';
import 'package:user_management_app/presentation/widgets/custom_dropdown.dart';
import 'package:user_management_app/presentation/widgets/loading_widget.dart';

class AddAddressScreen extends StatefulWidget {
  final String userId;

  const AddAddressScreen({super.key, required this.userId});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  // Variables para manejar las selecciones
  Country? _selectedCountry;
  Department? _selectedDepartment;
  Municipality? _selectedMunicipality;

  // Listas para los dropdowns
  List<Country> _countries = [];
  List<Department> _departments = [];
  List<Municipality> _municipalities = [];

  @override
  void initState() {
    super.initState();
    // Cargar países al inicializar con un delay para asegurar que el bloc esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AddressBloc>().add(const LoadCountries());
      }
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Dirección'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Finalizar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dirección agregada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            _clearForm();
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CountriesLoaded) {
            setState(() {
              _countries = state.countries;
              // Auto-seleccionar Colombia si solo hay un país
              if (state.countries.length == 1) {
                _selectedCountry = state.countries.first;
                // Cargar departamentos automáticamente
                context.read<AddressBloc>().add(
                  LoadDepartments(_selectedCountry!.id),
                );
              }
            });
          } else if (state is DepartmentsLoaded) {
            setState(() {
              _departments = state.departments;
              _municipalities =
                  []; // Limpiar municipios cuando cambian departamentos
              _selectedMunicipality = null;
            });
          } else if (state is MunicipalitiesLoaded) {
            setState(() {
              _municipalities = state.municipalities;
            });
          }
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading &&
                state is! CountriesLoaded &&
                state is! DepartmentsLoaded &&
                state is! MunicipalitiesLoaded) {
              return const LoadingWidget(message: 'Guardando dirección...');
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    const SizedBox(height: 32),
                    _buildButtons(state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.location_on,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Agregar Dirección',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Completa la información de la dirección',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // País (solo Colombia - deshabilitado)
        CustomDropdown<Country>(
          label: 'País',
          hint: 'Colombia',
          value: _selectedCountry,
          items: _countries,
          itemBuilder: (country) => country.name,
          onChanged: (country) {}, // Deshabilitado
          prefixIcon: Icons.public,
          validator: (value) =>
              null, // No validar ya que está auto-seleccionado
        ),
        const SizedBox(height: 16),

        // Dropdown de Departamento
        CustomDropdown<Department>(
          label: 'Departamento',
          hint: 'Selecciona un departamento',
          value: _selectedDepartment,
          items: _departments,
          itemBuilder: (department) => department.name,
          onChanged: (department) {
            setState(() {
              _selectedDepartment = department;
              _selectedMunicipality = null;
              _municipalities = [];
            });
            if (department != null) {
              context.read<AddressBloc>().add(
                LoadMunicipalities(department.id),
              );
            }
          },
          prefixIcon: Icons.location_city,
          validator: (value) =>
              value == null ? 'Selecciona un departamento' : null,
          isLoading: _departments.isEmpty,
        ),
        const SizedBox(height: 16),

        // Dropdown de Municipio
        CustomDropdown<Municipality>(
          label: 'Municipio',
          hint: _selectedDepartment == null
              ? 'Primero selecciona un departamento'
              : 'Selecciona un municipio',
          value: _selectedMunicipality,
          items: _municipalities,
          itemBuilder: (municipality) => municipality.name,
          onChanged: _selectedDepartment == null
              ? (municipality) {}
              : (municipality) {
                  setState(() {
                    _selectedMunicipality = municipality;
                  });
                },
          prefixIcon: Icons.home,
          validator: (value) =>
              value == null ? 'Selecciona un municipio' : null,
          isLoading: _selectedDepartment != null && _municipalities.isEmpty,
        ),
        const SizedBox(height: 16),

        // Campo de texto para la dirección
        CustomTextField(
          label: 'Dirección',
          hint: 'Ej: Calle 123 #45-67',
          controller: _streetController,
          validator: Validators.validateStreet,
          prefixIcon: const Icon(Icons.place),
        ),
        const SizedBox(height: 16),

        // Campo de texto para información adicional
        CustomTextField(
          label: 'Información Adicional (Opcional)',
          hint: 'Ej: Apartamento 201, Torre A',
          controller: _additionalInfoController,
          validator: Validators.validateAdditionalInfo,
          prefixIcon: const Icon(Icons.info_outline),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildButtons(AddressState state) {
    return Column(
      children: [
        CustomButton(
          text: 'Agregar Dirección',
          onPressed: _addAddress,
          isLoading: state is AddressLoading,
          icon: Icons.add_location,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearForm,
                icon: const Icon(Icons.clear),
                label: const Text('Limpiar'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Finalizar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.userId,
        country: _selectedCountry!.name,
        department: _selectedDepartment!.name,
        municipality: _selectedMunicipality!.name,
        street: _streetController.text.trim(),
        additionalInfo: _additionalInfoController.text.trim().isEmpty
            ? null
            : _additionalInfoController.text.trim(),
      );

      context.read<AddressBloc>().add(CreateAddress(address));
    }
  }

  void _clearForm() {
    setState(() {
      _selectedCountry = null;
      _selectedDepartment = null;
      _selectedMunicipality = null;
      _departments = [];
      _municipalities = [];
    });
    _streetController.clear();
    _additionalInfoController.clear();
  }
}
