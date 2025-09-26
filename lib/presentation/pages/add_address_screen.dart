import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/validators/validators.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';
import 'package:user_management_app/presentation/blocs/address/address_event.dart';
import 'package:user_management_app/presentation/blocs/address/address_state.dart';
import 'package:user_management_app/presentation/pages/home_screen.dart';
import 'package:user_management_app/presentation/theme/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Agregar Dirección'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
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

            return Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildFormCard(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              size: 30,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Agregar Dirección',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Completa la información de la dirección',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(AddressState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildFormFields()),
            const SizedBox(height: 16),
            _buildButtons(state),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Ubicación Geográfica', Icons.public),
          const SizedBox(height: 12),
          _buildModernDropdown<Country>(
            label: 'País',
            hint: 'Colombia',
            value: _selectedCountry,
            items: _countries,
            itemBuilder: (country) => country.name,
            onChanged: (country) {}, // Deshabilitado
            icon: Icons.public,
            validator: (value) => null,
          ),
          const SizedBox(height: 12),
          _buildModernDropdown<Department>(
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
            icon: Icons.location_city,
            validator: (value) =>
                value == null ? 'Selecciona un departamento' : null,
            isLoading: _departments.isEmpty,
          ),
          const SizedBox(height: 12),
          _buildModernDropdown<Municipality>(
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
            icon: Icons.home,
            validator: (value) =>
                value == null ? 'Selecciona un municipio' : null,
            isLoading: _selectedDepartment != null && _municipalities.isEmpty,
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Dirección', Icons.place),
          const SizedBox(height: 8),
          _buildModernTextField(
            label: 'Dirección',
            hint: 'Ej: Calle 123 #45-67',
            controller: _streetController,
            validator: Validators.validateStreet,
            icon: Icons.place,
          ),
          const SizedBox(height: 12),
          _buildModernTextField(
            label: 'Información Adicional (Opcional)',
            hint: 'Ej: Apartamento 201, Torre A',
            controller: _additionalInfoController,
            validator: Validators.validateAdditionalInfo,
            icon: Icons.info_outline,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdown<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    required IconData icon,
    required String? Function(T?) validator,
    bool isLoading = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 1,
            ),
            color: AppTheme.backgroundColor,
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemBuilder(item)),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
            isExpanded: true,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 1,
            ),
            color: AppTheme.backgroundColor,
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppTheme.primaryColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(AddressState state) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state is AddressLoading ? null : _addAddress,
            icon: state is AddressLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.add_location, size: 20),
            label: Text(
              state is AddressLoading ? 'Agregando...' : 'Agregar Dirección',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearForm,
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Limpiar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textSecondaryColor,
                  side: BorderSide(
                    color: AppTheme.textSecondaryColor.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Finalizar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.successColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
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
