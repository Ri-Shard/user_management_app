import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';
import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/data/datasources/user_local_datasource.dart';
import 'package:user_management_app/data/models/models.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, User>> createUser(CreateUserParams params) async {
    try {
      final userModel = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: params.firstName,
        lastName: params.lastName,
        birthDate: params.birthDate,
        addresses: const [],
      );

      final createdUser = await localDataSource.createUser(userModel);
      return Right(createdUser.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error creating user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final userModels = await localDataSource.getUsers();
      final users = userModels.map((model) => model.toEntity()).toList();
      return Right(users);
    } catch (e) {
      return Left(CacheFailure('Error getting users: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(String id) async {
    try {
      final userModel = await localDataSource.getUserById(id);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error getting user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser = await localDataSource.updateUser(userModel);
      return Right(updatedUser.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error updating user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await localDataSource.deleteUser(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error deleting user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromEntity(address);
      final createdAddress = await localDataSource.addAddress(addressModel);
      return Right(createdAddress.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error adding address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Address>>> getUserAddresses(String userId) async {
    try {
      final addressModels = await localDataSource.getUserAddresses(userId);
      final addresses = addressModels.map((model) => model.toEntity()).toList();
      return Right(addresses);
    } catch (e) {
      return Left(CacheFailure('Error getting addresses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Address>> updateAddress(Address address) async {
    try {
      final addressModel = AddressModel.fromEntity(address);
      final updatedAddress = await localDataSource.updateAddress(addressModel);
      return Right(updatedAddress.toEntity());
    } catch (e) {
      return Left(CacheFailure('Error updating address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await localDataSource.deleteAddress(addressId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Error deleting address: ${e.toString()}'));
    }
  }
}
