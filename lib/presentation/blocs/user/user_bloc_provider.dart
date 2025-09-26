import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/injection/injection.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart';
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';

class UserBlocProvider extends StatelessWidget {
  final Widget child;

  const UserBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(
        getUsers: getIt<GetUsers>(),
        getUserById: getIt<GetUserById>(),
        createUser: getIt<CreateUser>(),
        updateUser: getIt<UpdateUser>(),
        deleteUser: getIt<DeleteUser>(),
      ),
      child: child,
    );
  }
}
