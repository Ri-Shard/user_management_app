import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/data/datasources/user_local_datasource.dart';
import 'package:user_management_app/data/models/models.dart';
import 'package:user_management_app/data/repositories/user_repository_impl.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockUserLocalDataSource();
    repository = UserRepositoryImpl(localDataSource: mockDataSource);
  });

  group('createUser', () {
    final tCreateUserParams = CreateUserParams(
      firstName: 'Juan',
      lastName: 'Pérez',
      birthDate: DateTime(1990, 5, 15),
    );

    final tUserModel = UserModel(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      birthDate: DateTime(1990, 5, 15),
    );

    final tUser = User(
      id: '1',
      firstName: 'Juan',
      lastName: 'Pérez',
      birthDate: DateTime(1990, 5, 15),
    );

    test('should return user when data source succeeds', () async {
      // Arrange
      when(
        () => mockDataSource.createUser(any()),
      ).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.createUser(tCreateUserParams);

      // Assert
      expect(result, Right(tUser));
      verify(() => mockDataSource.createUser(any())).called(1);
    });

    test('should return failure when data source throws exception', () async {
      // Arrange
      when(
        () => mockDataSource.createUser(any()),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.createUser(tCreateUserParams);

      // Assert
      expect(result, isA<Left<Failure, User>>());
      verify(() => mockDataSource.createUser(any())).called(1);
    });
  });
}
