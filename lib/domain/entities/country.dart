class Country {
  final String id;
  final String name;
  final String code;

  const Country({required this.id, required this.name, required this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country &&
        other.id == id &&
        other.name == name &&
        other.code == code;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ code.hashCode;

  @override
  String toString() => 'Country(id: $id, name: $name, code: $code)';
}
