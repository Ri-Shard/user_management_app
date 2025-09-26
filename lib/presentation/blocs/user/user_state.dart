import 'package:equatable/equatable.dart';
import 'package:user_management_app/domain/entities/entities.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;

  const UserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserLoadedSingle extends UserState {
  final User user;

  const UserLoadedSingle(this.user);

  @override
  List<Object?> get props => [user];
}

class UserCreated extends UserState {
  final User user;

  const UserCreated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final User user;

  const UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends UserState {
  final String userId;

  const UserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
