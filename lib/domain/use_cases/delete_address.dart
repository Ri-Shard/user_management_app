import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class DeleteAddress {
  final UserRepository repository;

  DeleteAddress(this.repository);

  Future<Either<Failure, void>> call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
