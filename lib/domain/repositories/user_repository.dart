import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createUser(CreateUserParams params);
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> getUserById(String id);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> deleteUser(String id);

  // Address methods
  Future<Either<Failure, Address>> addAddress(Address address);
  Future<Either<Failure, List<Address>>> getUserAddresses(String userId);
  Future<Either<Failure, Address>> updateAddress(Address address);
  Future<Either<Failure, void>> deleteAddress(String addressId);
}
