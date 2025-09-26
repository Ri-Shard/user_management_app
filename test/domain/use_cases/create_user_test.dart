import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_management_app/core/core.dart';
import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/user_repository.dart';
import 'package:user_management_app/domain/use_cases/create_user.dart';
import 'package:user_management_app/domain/use_cases/create_user_params.dart';

class MockUserRepository extends Mock implements UserRepository {}

class FakeCreateUserParams extends Fake implements CreateUserParams {}

void main() {
  late CreateUser useCase;
  late MockUserRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCreateUserParams());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = CreateUser(mockRepository);
  });

  group('CreateUser', () {
    final tCreateUserParams = CreateUserParams(
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

    test('should create user successfully', () async {
      // Arrange
      when(
        () => mockRepository.createUser(any()),
      ).thenAnswer((_) async => Right(tUser));

      // Act
      final result = await useCase(tCreateUserParams);

      // Assert
      result.fold(
        (failure) => fail('Expected Right but got Left: $failure'),
        (user) => {
          expect(user.firstName, equals(tUser.firstName)),
          expect(user.lastName, equals(tUser.lastName)),
        },
      );
      verify(() => mockRepository.createUser(tCreateUserParams)).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      const tFailure = CacheFailure('Error creating user');
      when(
        () => mockRepository.createUser(any()),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase(tCreateUserParams);

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (user) => fail('Expected Left but got Right: $user'),
      );
      verify(() => mockRepository.createUser(tCreateUserParams)).called(1);
    });
  });
}
