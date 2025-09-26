import 'package:equatable/equatable.dart';
import 'package:user_management_app/domain/entities/entities.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<Address> addresses;

  const AddressLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressCreated extends AddressState {
  final Address address;

  const AddressCreated(this.address);

  @override
  List<Object?> get props => [address];
}

class AddressUpdated extends AddressState {
  final Address address;

  const AddressUpdated(this.address);

  @override
  List<Object?> get props => [address];
}

class AddressDeleted extends AddressState {
  final String addressId;

  const AddressDeleted(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class AddressError extends AddressState {
  final String message;

  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
