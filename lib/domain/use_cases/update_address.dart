import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class UpdateAddress {
  final UserRepository repository;

  UpdateAddress(this.repository);

  Future<Either<Failure, Address>> call(Address address) async {
    return await repository.updateAddress(address);
  }
}
