import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:vocaday_app/features/authentication/domain/usecases/auth_state_changed.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Stream<User?> get user => Stream.fromIterable([_mockUser]);
}

void main() {
  late AuthStateChangedUsecase authStateChangedUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authStateChangedUsecase = AuthStateChangedUsecase(
      repository: mockAuthRepository,
    );
  });

  test('should return user auth state changed', () {
    expectLater(authStateChangedUsecase.user, emitsInOrder([_mockUser]));
  });
}
