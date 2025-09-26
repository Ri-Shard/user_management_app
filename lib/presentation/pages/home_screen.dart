import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';
import 'package:user_management_app/presentation/pages/create_user_screen.dart';
import 'package:user_management_app/presentation/widgets/loading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay usuarios registrados',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para crear tu primer usuario',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, List<User> users) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(RefreshUsers());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(context, user);
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            '${user.firstName[0]}${user.lastName[0]}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nacimiento: ${_formatDate(user.birthDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Direcciones: ${user.addresses.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                _showUserDetails(context, user);
                break;
              case 'edit':
                _editUser(context, user);
                break;
              case 'delete':
                _deleteUser(context, user);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: ListTile(
                leading: Icon(Icons.visibility),
                title: Text('Ver detalles'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () => _showUserDetails(context, user),
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${user.firstName} ${user.lastName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Nombre', user.firstName),
              _buildDetailRow('Apellido', user.lastName),
              _buildDetailRow(
                'Fecha de nacimiento',
                _formatDate(user.birthDate),
              ),
              _buildDetailRow('Edad', '${_calculateAge(user.birthDate)} años'),
              const SizedBox(height: 16),
              Text(
                'Direcciones (${user.addresses.length})',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (user.addresses.isEmpty)
                Text(
                  'No hay direcciones registradas',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                )
              else
                ...user.addresses.map(
                  (address) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.street,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${address.municipality}, ${address.department}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            address.country,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (address.additionalInfo != null)
                            Text(
                              address.additionalInfo!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
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
