import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart'
    as use_cases;
import 'package:user_management_app/presentation/blocs/user/user_event.dart';
import 'package:user_management_app/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final use_cases.GetUsers getUsers;
  final use_cases.GetUserById getUserById;
  final use_cases.CreateUser createUser;
  final use_cases.UpdateUser updateUser;
  final use_cases.DeleteUser deleteUser;

  UserBloc({
    required this.getUsers,
    required this.getUserById,
    required this.createUser,
    required this.updateUser,
    required this.deleteUser,
  }) : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserById>(_onLoadUserById);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await getUsers();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }

  Future<void> _onLoadUserById(
    LoadUserById event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    final result = await getUserById(event.userId);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoadedSingle(user)),
    );
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await createUser(event.params);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserCreated(user)),
    );
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await updateUser(event.user);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserUpdated(user)),
    );
  }

  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    final result = await deleteUser(event.userId);
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(UserDeleted(event.userId)),
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsers event,
    Emitter<UserState> emit,
  ) async {
    final result = await getUsers();
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (users) => emit(UserLoaded(users)),
    );
  }
}
