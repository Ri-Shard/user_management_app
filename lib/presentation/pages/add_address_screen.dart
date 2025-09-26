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
import 'package:user_management_app/presentation/widgets/loading_widget.dart';

class AddAddressScreen extends StatefulWidget {
  final String userId;

  const AddAddressScreen({super.key, required this.userId});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController();
  final _departmentController = TextEditingController();
  final _municipalityController = TextEditingController();
  final _streetController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  @override
  void dispose() {
    _countryController.dispose();
    _departmentController.dispose();
    _municipalityController.dispose();
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
          }
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
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
        CustomTextField(
          label: 'País',
          hint: 'Ej: Colombia',
          controller: _countryController,
          validator: Validators.validateCountry,
          prefixIcon: const Icon(Icons.public),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Departamento',
          hint: 'Ej: Cundinamarca',
          controller: _departmentController,
          validator: Validators.validateDepartment,
          prefixIcon: const Icon(Icons.location_city),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Municipio',
          hint: 'Ej: Bogotá',
          controller: _municipalityController,
          validator: Validators.validateMunicipality,
          prefixIcon: const Icon(Icons.home),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Dirección',
          hint: 'Ej: Calle 123 #45-67',
          controller: _streetController,
          validator: Validators.validateStreet,
          prefixIcon: const Icon(Icons.place),
        ),
        const SizedBox(height: 16),
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
        country: _countryController.text.trim(),
        department: _departmentController.text.trim(),
        municipality: _municipalityController.text.trim(),
        street: _streetController.text.trim(),
        additionalInfo: _additionalInfoController.text.trim().isEmpty
            ? null
            : _additionalInfoController.text.trim(),
      );

      context.read<AddressBloc>().add(CreateAddress(address));
    }
  }

  void _clearForm() {
    _countryController.clear();
    _departmentController.clear();
    _municipalityController.clear();
    _streetController.clear();
    _additionalInfoController.clear();
  }
}
