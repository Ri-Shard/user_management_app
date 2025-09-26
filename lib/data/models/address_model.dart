import 'package:user_management_app/domain/entities/entities.dart';

class AddressModel {
  final String id;
  final String userId;
  final String country;
  final String department;
  final String municipality;
  final String street;
  final String? additionalInfo;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.country,
    required this.department,
    required this.municipality,
    required this.street,
    this.additionalInfo,
  });

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      userId: address.userId,
      country: address.country,
      department: address.department,
      municipality: address.municipality,
      street: address.street,
      additionalInfo: address.additionalInfo,
    );
  }

  Address toEntity() {
    return Address(
      id: id,
      userId: userId,
      country: country,
      department: department,
      municipality: municipality,
      street: street,
      additionalInfo: additionalInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'country': country,
      'department': department,
      'municipality': municipality,
      'street': street,
      'additionalInfo': additionalInfo,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      userId: json['userId'],
      country: json['country'],
      department: json['department'],
      municipality: json['municipality'],
      street: json['street'],
      additionalInfo: json['additionalInfo'],
    );
  }
}
