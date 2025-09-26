import 'package:user_management_app/data/models/models.dart';

abstract class UserLocalDataSource {
  Future<UserModel> createUser(UserModel user);
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(String id);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);

  Future<AddressModel> addAddress(AddressModel address);
  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
}
