import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/authentication/data/models/auth_model.dart';
import 'package:vocaday_app/features/authentication/domain/entities/auth_entity.dart';
import 'package:vocaday_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:vocaday_app/features/authentication/domain/usecases/sign_up_with_email_password.dart';
import 'package:vocaday_app/features/user/user_cart/domain/repositories/cart_repository.dart';
import 'package:vocaday_app/features/user/user_profile/domain/repositories/user_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockCartRepository extends Mock implements CartRepository {}

class MockUser extends Mock implements User {}

void main() {
  final mockUser = MockUser();
  late SignUpWithEmailPasswordUsecase signUpWithEmailPasswordUsecase;
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late MockCartRepository mockCartRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    mockCartRepository = MockCartRepository();
    signUpWithEmailPasswordUsecase = SignUpWithEmailPasswordUsecase(
      authRepository: mockAuthRepository,
      userRepository: mockUserRepository,
      cartRepository: mockCartRepository,
    );
  });

  const testEmail = "test@gm.com";
  const testPass = "test12345";

  final testEntity = AuthEntity(
    uid: 'uid',
    user: mockUser,
    isNewUser: false,
    signInMethod: SignInMethod.none,
  );

  group('Sign Up Usecase', () {
    test('should return [AuthEntity] class from repository', () async {
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
          testEmail, testPass)).thenAnswer((_) async => Right(testEntity));
      final result =
          await signUpWithEmailPasswordUsecase((testEmail, testPass));
      expect(result, Right(testEntity));
    });
    test('should return [ServerFailure] from repository', () async {
      when(() => mockAuthRepository.signUpWithEmailAndPassword(
              testEmail, testPass))
          .thenAnswer((_) async => const Left(ServerFailure("Weak password")));
      final result =
          await signUpWithEmailPasswordUsecase((testEmail, testPass));
      expect(result, const Left(ServerFailure("Weak password")));
    });
  });
}
