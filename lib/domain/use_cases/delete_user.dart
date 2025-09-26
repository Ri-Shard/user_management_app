import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<Either<Failure, void>> call(String userId) async {
    return await repository.deleteUser(userId);
  }
}
