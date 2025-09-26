import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';
import 'package:user_management_app/presentation/pages/create_user_screen.dart';
import 'package:user_management_app/presentation/theme/app_theme.dart';
import 'package:user_management_app/presentation/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios automáticamente al inicializar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserBloc>().add(LoadUsers());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<UserBloc>().add(RefreshUsers());
            },
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const LoadingWidget(message: 'Cargando usuarios...');
          } else if (state is UserError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<UserBloc>().add(LoadUsers());
              },
            );
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildUsersList(context, state.users);
          }
          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateUserScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No hay usuarios registrados',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Toca el botón + para crear tu primer usuario',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, List<User> users) {
    // Invertir el orden para mostrar los más recientes primero
    final reversedUsers = users.reversed.toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(RefreshUsers());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reversedUsers.length,
        itemBuilder: (context, index) {
          final user = reversedUsers[index];
          return _buildUserCard(context, user);
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar con indicador de estado
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${user.firstName[0]}${user.lastName[0]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Información del usuario
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Usuario (Edad: ${_calculateAge(user.birthDate)} años)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Sección de direcciones
            if (user.addresses.isNotEmpty) ...[
              Text(
                'Direcciones (${user.addresses.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildAddressesSection(user.addresses),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.textSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_off,
                      color: AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No hay direcciones registradas',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Botón de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUserDetails(context, user),
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: const Text('Ver Detalles'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Menú de opciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  Icons.edit,
                  'Editar',
                  () => _editUser(context, user),
                ),
                _buildActionButton(
                  context,
                  Icons.delete,
                  'Eliminar',
                  () => _deleteUser(context, user),
                  isDestructive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesSection(List<Address> addresses) {
    if (addresses.length <= 2) {
      // Mostrar direcciones directamente si son pocas
      return Column(
        children: addresses
            .map((address) => _buildAddressCard(address))
            .toList(),
      );
    } else {
      // Mostrar carrusel si hay muchas direcciones
      return SizedBox(
        height: 120,
        child: PageView.builder(
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildAddressCard(addresses[index]),
            );
          },
        ),
      );
    }
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address.street,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${address.municipality}, ${address.department}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          Text(
            address.country,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (address.additionalInfo != null &&
              address.additionalInfo!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address.additionalInfo!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 16,
        color: isDestructive
            ? AppTheme.errorColor
            : Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDestructive
              ? AppTheme.errorColor
              : Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con avatar
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
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
                      child: Center(
                        child: Text(
                          '${user.firstName[0]}${user.lastName[0]}',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Usuario (${_calculateAge(user.birthDate)} años)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información personal
                      _buildDetailSection(
                        'Información Personal',
                        Icons.person,
                        [
                          _buildDetailItem('Nombre', user.firstName),
                          _buildDetailItem('Apellido', user.lastName),
                          _buildDetailItem(
                            'Fecha de nacimiento',
                            _formatDate(user.birthDate),
                          ),
                          _buildDetailItem(
                            'Edad',
                            '${_calculateAge(user.birthDate)} años',
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Direcciones
                      _buildDetailSection(
                        'Direcciones (${user.addresses.length})',
                        Icons.location_on,
                        user.addresses.isEmpty
                            ? [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.textSecondaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_off,
                                        color: AppTheme.textSecondaryColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'No hay direcciones registradas',
                                        style: TextStyle(
                                          color: AppTheme.textSecondaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            : user.addresses
                                  .map(
                                    (address) =>
                                        _buildAddressCardDialog(address),
                                  )
                                  .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Botones de acción
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _editUser(context, user),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Editar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: BorderSide(color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Cerrar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCardDialog(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  address.street,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${address.municipality}, ${address.department}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          Text(
            address.country,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          if (address.additionalInfo != null &&
              address.additionalInfo!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              address.additionalInfo!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _editUser(BuildContext context, User user) {
    // TODO: Implementar edición de usuario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición próximamente')),
    );
  }

  void _deleteUser(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${user.firstName} ${user.lastName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserBloc>().add(DeleteUser(user.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario eliminado')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
