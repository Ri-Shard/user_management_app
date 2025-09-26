import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<Either<Failure, User>> call(CreateUserParams params) async {
    return await repository.createUser(params);
  }
}
