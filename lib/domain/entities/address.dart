class Address {
  final String id;
  final String userId;
  final String country;
  final String department;
  final String municipality;
  final String street;
  final String? additionalInfo;

  const Address({
    required this.id,
    required this.userId,
    required this.country,
    required this.department,
    required this.municipality,
    required this.street,
    this.additionalInfo,
  });

  Address copyWith({
    String? id,
    String? userId,
    String? country,
    String? department,
    String? municipality,
    String? street,
    String? additionalInfo,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      country: country ?? this.country,
      department: department ?? this.department,
      municipality: municipality ?? this.municipality,
      street: street ?? this.street,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.id == id &&
        other.userId == userId &&
        other.country == country &&
        other.department == department &&
        other.municipality == municipality &&
        other.street == street &&
        other.additionalInfo == additionalInfo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        country.hashCode ^
        department.hashCode ^
        municipality.hashCode ^
        street.hashCode ^
        additionalInfo.hashCode;
  }

  @override
  String toString() {
    return 'Address(id: $id, userId: $userId, country: $country, department: $department, municipality: $municipality, street: $street, additionalInfo: $additionalInfo)';
  }
}
