import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:vocaday_app/features/authentication/domain/usecases/sign_in_with_email_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInWithEmailPasswordUsecase signInWithEmailPasswordUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInWithEmailPasswordUsecase = SignInWithEmailPasswordUsecase(
      repository: mockAuthRepository,
    );
  });

  const testEmail = "test@gm.com";
  const testPass = "test12345";

  final voidVal = Future<void>.value();

  group('Sign In Usecase', () {
    test('should return [void] from repository', () async {
      when(() => mockAuthRepository.signInWithEmailAndPassword(
          testEmail, testPass)).thenAnswer((_) async => Right(voidVal));
      final result =
          await signInWithEmailPasswordUsecase((testEmail, testPass));
      expect(result, Right(voidVal));
    });
    test('should return [ServerFailure] from repository', () async {
      when(() => mockAuthRepository.signInWithEmailAndPassword(
              testEmail, testPass))
          .thenAnswer((_) async => const Left(ServerFailure("Invalid email")));
      final result =
          await signInWithEmailPasswordUsecase((testEmail, testPass));
      expect(result, const Left(ServerFailure("Invalid email")));
    });
  });
}
