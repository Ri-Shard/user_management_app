import 'package:equatable/equatable.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UserEvent {}

class LoadUserById extends UserEvent {
  final String userId;

  const LoadUserById(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateUser extends UserEvent {
  final CreateUserParams params;

  const CreateUser(this.params);

  @override
  List<Object?> get props => [params];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteUser extends UserEvent {
  final String userId;

  const DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RefreshUsers extends UserEvent {}
