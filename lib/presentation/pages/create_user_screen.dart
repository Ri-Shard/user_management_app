import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:user_management_app/core/validators/validators.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';
import 'package:user_management_app/presentation/pages/add_address_screen.dart';
import 'package:user_management_app/presentation/theme/app_theme.dart';
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Crear Usuario'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
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

            return Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildFormCard()),
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
              Icons.person_add,
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
                  'Crear Nuevo Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Completa la información básica',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
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
            _buildCreateButton(),
            const SizedBox(height: 8),
            _buildSkipButton(),
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
          _buildSectionTitle('Información Personal', Icons.person),
          const SizedBox(height: 8),
          _buildModernTextField(
            label: 'Nombre',
            hint: 'Ingresa el nombre',
            controller: _firstNameController,
            validator: Validators.validateFirstName,
            icon: Icons.person,
          ),
          const SizedBox(height: 8),
          _buildModernTextField(
            label: 'Apellido',
            hint: 'Ingresa el apellido',
            controller: _lastNameController,
            validator: Validators.validateLastName,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildSectionTitle('Fecha de Nacimiento', Icons.cake),
          const SizedBox(height: 6),
          _buildModernDateField(),
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

  Widget _buildModernTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required IconData icon,
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

  Widget _buildModernDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha de Nacimiento',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
              color: AppTheme.backgroundColor,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                        : 'Selecciona la fecha de nacimiento',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
              ],
            ),
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.cake, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Edad: ${_calculateAge(_selectedDate!)} años',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCreateButton() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state is UserLoading ? null : _createUser,
            icon: state is UserLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.person_add, size: 20),
            label: Text(
              state is UserLoading ? 'Creando...' : 'Crear Usuario',
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
        );
      },
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, size: 18),
        label: const Text('Cancelar'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textSecondaryColor,
          side: BorderSide(color: AppTheme.textSecondaryColor.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
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
