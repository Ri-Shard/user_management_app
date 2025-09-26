class Department {
  final String id;
  final String name;
  final String countryId;

  const Department({
    required this.id,
    required this.name,
    required this.countryId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Department &&
        other.id == id &&
        other.name == name &&
        other.countryId == countryId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ countryId.hashCode;

  @override
  String toString() =>
      'Department(id: $id, name: $name, countryId: $countryId)';
}
