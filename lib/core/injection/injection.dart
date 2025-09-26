import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:user_management_app/data/datasources/user_local_datasource_impl.dart';
import 'package:user_management_app/data/repositories/user_repository_impl.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  // Data Sources
  getIt.registerLazySingleton<UserLocalDataSourceImpl>(
    () => UserLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: getIt<UserLocalDataSourceImpl>()),
  );

  // Use Cases
  getIt.registerLazySingleton<CreateUser>(
    () => CreateUser(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUsers>(
    () => GetUsers(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserById>(
    () => GetUserById(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<AddAddress>(
    () => AddAddress(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<GetUserAddresses>(
    () => GetUserAddresses(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<UpdateUser>(
    () => UpdateUser(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<DeleteUser>(
    () => DeleteUser(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<UpdateAddress>(
    () => UpdateAddress(getIt<UserRepository>()),
  );

  getIt.registerLazySingleton<DeleteAddress>(
    () => DeleteAddress(getIt<UserRepository>()),
  );
}
