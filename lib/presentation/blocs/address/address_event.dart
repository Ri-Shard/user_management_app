import 'package:equatable/equatable.dart';
import 'package:user_management_app/domain/entities/entities.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserAddresses extends AddressEvent {
  final String userId;

  const LoadUserAddresses(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateAddress extends AddressEvent {
  final Address address;

  const CreateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final Address address;

  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends AddressEvent {
  final String addressId;

  const DeleteAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class RefreshAddresses extends AddressEvent {
  final String userId;

  const RefreshAddresses(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadCountries extends AddressEvent {
  const LoadCountries();

  @override
  List<Object?> get props => [];
}

class LoadDepartments extends AddressEvent {
  final String countryId;

  const LoadDepartments(this.countryId);

  @override
  List<Object?> get props => [countryId];
}

class LoadMunicipalities extends AddressEvent {
  final String departmentId;

  const LoadMunicipalities(this.departmentId);

  @override
  List<Object?> get props => [departmentId];
}
