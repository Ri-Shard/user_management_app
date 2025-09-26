import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/injection/injection.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart'
    as use_cases;
import 'package:user_management_app/presentation/blocs/user/user_bloc.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            getUsers: getIt<use_cases.GetUsers>(),
            getUserById: getIt<use_cases.GetUserById>(),
            createUser: getIt<use_cases.CreateUser>(),
            updateUser: getIt<use_cases.UpdateUser>(),
            deleteUser: getIt<use_cases.DeleteUser>(),
          ),
        ),
        BlocProvider<AddressBloc>(
          create: (context) => AddressBloc(
            getUserAddresses: getIt<use_cases.GetUserAddresses>(),
            addAddress: getIt<use_cases.AddAddress>(),
            updateAddress: getIt<use_cases.UpdateAddress>(),
            deleteAddress: getIt<use_cases.DeleteAddress>(),
            getCountries: getIt<use_cases.GetCountries>(),
            getDepartmentsByCountry: getIt<use_cases.GetDepartmentsByCountry>(),
            getMunicipalitiesByDepartment:
                getIt<use_cases.GetMunicipalitiesByDepartment>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
