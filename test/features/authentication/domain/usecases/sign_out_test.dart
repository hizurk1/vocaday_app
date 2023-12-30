import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:vocaday_app/features/authentication/domain/usecases/sign_out.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignOutUsecase signOutUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signOutUsecase = SignOutUsecase(
      repository: mockAuthRepository,
    );
  });

  final voidVal = Future<void>.value();

  group('Sign Out Usecase', () {
    test('should return [void] from repository', () async {
      when(() => mockAuthRepository.signOut())
          .thenAnswer((_) async => Right(voidVal));
      final result = await signOutUsecase();
      expect(result, Right(voidVal));
    });
    test('should return [ServerFailure] from repository', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer(
          (_) async => const Left(ServerFailure("Sign Out Failed")));
      final result = await signOutUsecase();
      expect(result, const Left(ServerFailure("Sign Out Failed")));
    });
  });
}
