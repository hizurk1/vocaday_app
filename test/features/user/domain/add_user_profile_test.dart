import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/user/user_profile/domain/entities/user_entity.dart';
import 'package:vocaday_app/features/user/user_profile/domain/repositories/user_repository.dart';
import 'package:vocaday_app/features/user/user_profile/domain/usecases/add_user_profile.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late AddUserProfile addUserProfile;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    addUserProfile = AddUserProfile(repository: mockUserRepository);
  });

  const testUserEntity = UserEntity(
    uid: 'uid',
    name: 'name',
    email: 'email',
  );

  final voidVal = Future<void>.value();

  group('Add user profile usecase', () {
    test('should get [void] when call repo', () async {
      when(() => mockUserRepository.addUserProfile(testUserEntity))
          .thenAnswer((_) async => Right(voidVal));

      final result = await addUserProfile(testUserEntity);

      expect(result, Right(voidVal));
    });
    test('should get [DatabaseFailure] when call repo', () async {
      when(() => mockUserRepository.addUserProfile(testUserEntity))
          .thenAnswer((_) async => const Left(DatabaseFailure("Fail")));

      final result = await addUserProfile(testUserEntity);

      expect(result, const Left(DatabaseFailure("Fail")));
    });
  });
}
