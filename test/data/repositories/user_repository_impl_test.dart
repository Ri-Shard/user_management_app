import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/data/datasources/user_local_datasource.dart';
import 'package:user_management_app/data/models/models.dart';
import 'package:user_management_app/data/repositories/user_repository_impl.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

class MockUserLocalDataSource extends Mock implements UserLocalDataSource {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

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
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (user) => {
          expect(user.firstName, equals(tUser.firstName)),
          expect(user.lastName, equals(tUser.lastName)),
        },
      );
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
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (user) => fail('Expected Left but got Right: $user'),
      );
      verify(() => mockDataSource.createUser(any())).called(1);
    });
  });
}
