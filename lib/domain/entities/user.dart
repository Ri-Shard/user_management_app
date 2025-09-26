import 'package:user_management_app/domain/entities/entities.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.addresses = const [],
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.birthDate == birthDate &&
        _listEquals(other.addresses, addresses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        birthDate.hashCode ^
        addresses.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, addresses: $addresses)';
  }

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
