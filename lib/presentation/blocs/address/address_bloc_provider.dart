import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/core/injection/injection.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart';
import 'package:user_management_app/presentation/blocs/address/address_bloc.dart';

class AddressBlocProvider extends StatelessWidget {
  final Widget child;

  const AddressBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
      create: (context) => AddressBloc(
        getUserAddresses: getIt<GetUserAddresses>(),
        addAddress: getIt<AddAddress>(),
        updateAddress: getIt<UpdateAddress>(),
        deleteAddress: getIt<DeleteAddress>(),
      ),
      child: child,
    );
  }
}
