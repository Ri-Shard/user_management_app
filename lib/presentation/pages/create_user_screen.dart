import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_management_app/core/validators/validators.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';
import 'package:user_management_app/presentation/pages/add_address_screen.dart';
import 'package:user_management_app/presentation/widgets/custom_button.dart';
import 'package:user_management_app/presentation/widgets/custom_text_field.dart';
import 'package:user_management_app/presentation/widgets/loading_widget.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuario creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddAddressScreen(userId: state.user.id),
              ),
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const LoadingWidget(message: 'Creando usuario...');
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
                    _buildCreateButton(state),
                    const SizedBox(height: 16),
                    _buildSkipButton(),
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
          Icons.person_add,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Crear Nuevo Usuario',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Completa la información básica del usuario',
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
          label: 'Nombre',
          hint: 'Ingresa el nombre',
          controller: _firstNameController,
          validator: Validators.validateFirstName,
          prefixIcon: const Icon(Icons.person),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Apellido',
          hint: 'Ingresa el apellido',
          controller: _lastNameController,
          validator: Validators.validateLastName,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 16),
        _buildDateField(),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Nacimiento',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Selecciona la fecha de nacimiento',
                    style: TextStyle(
                      color: _selectedDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 8),
          Text(
            'Edad: ${_calculateAge(_selectedDate!)} años',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCreateButton(UserState state) {
    return CustomButton(
      text: 'Crear Usuario',
      onPressed: _createUser,
      isLoading: state is UserLoading,
      icon: Icons.person_add,
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancelar'),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createUser() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final params = CreateUserParams(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _selectedDate!,
      );

      context.read<UserBloc>().add(CreateUser(params));
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona la fecha de nacimiento'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
