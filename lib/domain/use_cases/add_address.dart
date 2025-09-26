import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';

class AddAddress {
  final UserRepository repository;

  AddAddress(this.repository);

  Future<Either<Failure, Address>> call(Address address) async {
    return await repository.addAddress(address);
  }
}
