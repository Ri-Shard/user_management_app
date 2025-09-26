class CreateUserParams {
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  const CreateUserParams({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });
}
