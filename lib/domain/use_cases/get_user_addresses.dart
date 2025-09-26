import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class GetUserAddresses {
  final UserRepository repository;

  GetUserAddresses(this.repository);

  Future<Either<Failure, List<Address>>> call(String userId) async {
    return await repository.getUserAddresses(userId);
  }
}
