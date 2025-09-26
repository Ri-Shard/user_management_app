class Municipality {
  final String id;
  final String name;
  final String departmentId;

  const Municipality({
    required this.id,
    required this.name,
    required this.departmentId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Municipality &&
        other.id == id &&
        other.name == name &&
        other.departmentId == departmentId;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ departmentId.hashCode;

  @override
  String toString() =>
      'Municipality(id: $id, name: $name, departmentId: $departmentId)';
}
