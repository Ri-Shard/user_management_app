import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';
import 'package:user_management_app/presentation/pages/create_user_screen.dart';
import 'package:user_management_app/presentation/theme/app_theme.dart';
import 'package:user_management_app/presentation/widgets/loading_widget.dart';
import 'package:user_management_app/presentation/widgets/user_card.dart';
import 'package:user_management_app/presentation/widgets/user_details_dialog.dart';
import 'package:user_management_app/presentation/widgets/empty_state_widget.dart';

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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Gestión de Usuarios'),
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<UserBloc>().add(RefreshUsers()),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocListener<UserBloc, UserState>(
      listener: _handleBlocStates,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return switch (state) {
            UserLoading() => const LoadingWidget(
              message: 'Cargando usuarios...',
            ),
            UserError() => CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<UserBloc>().add(LoadUsers()),
            ),
            UserLoaded() =>
              state.users.isEmpty
                  ? const EmptyStateWidget.users()
                  : _buildUsersList(state.users),
            _ => const EmptyStateWidget.users(),
          };
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateUserScreen()),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nuevo Usuario'),
    );
  }

  Widget _buildUsersList(List<User> users) {
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
          return UserCard(
            user: user,
            onTap: () => UserDetailsDialog.show(context, user),
            onEdit: () => _editUser(user),
            onDelete: () => _deleteUser(user),
          );
        },
      ),
    );
  }

  void _handleBlocStates(BuildContext context, UserState state) {
    switch (state) {
      case UserDeleted():
        _showSuccessMessage('Usuario eliminado exitosamente');
        context.read<UserBloc>().add(LoadUsers());
        break;
      case UserCreated():
        context.read<UserBloc>().add(LoadUsers());
        break;
      case UserUpdated():
        context.read<UserBloc>().add(LoadUsers());
        break;
      default:
        break;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.successColor),
    );
  }

  void _editUser(User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de edición próximamente')),
    );
  }

  void _deleteUser(User user) {
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
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
