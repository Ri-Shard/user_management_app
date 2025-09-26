import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/data/models/address_model.dart';

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<AddressModel> addresses;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
  });

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      birthDate: user.birthDate,
      addresses: user.addresses
          .map((address) => AddressModel.fromEntity(address))
          .toList(),
    );
  }

  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      addresses: addresses.map((model) => model.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'addresses': addresses.map((address) => address.toJson()).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: DateTime.parse(json['birthDate']),
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((address) => AddressModel.fromJson(address))
              .toList() ??
          [],
    );
  }
}
