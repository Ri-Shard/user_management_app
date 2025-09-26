import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<Either<Failure, User>> call(String id) async {
    return await repository.getUserById(id);
  }
}
