import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/exception.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:vocaday_app/features/authentication/data/models/auth_model.dart';
import 'package:vocaday_app/features/authentication/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockUser extends Mock implements User {}

void main() {
  final mockUser = MockUser();
  late AuthRepositoryImpl authRepositoryImpl;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;
  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    authRepositoryImpl = AuthRepositoryImpl(mockAuthRemoteDataSource);
  });

  const testEmail = "test@gm.com";
  const testPass = "test12345";

  final voidVal = Future<void>.value();

  final testModel = AuthModel(
    uid: 'uid',
    user: mockUser,
    signInMethod: SignInMethod.none,
  );

  group('Sign Up', () {
    test('should return [AuthEntity] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signUpWithEmailAndPassword(
          testEmail, testPass)).thenAnswer((_) async => testModel);
      final result = await authRepositoryImpl.signUpWithEmailAndPassword(
          testEmail, testPass);
      result.fold(
        (l) => fail(l.message),
        (r) => expect(r, testModel.toEntity()),
      );
    });
    test('should return [ServerFailure] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signUpWithEmailAndPassword(
          testEmail, testPass)).thenThrow(ServerException("fail"));
      final result = await authRepositoryImpl.signUpWithEmailAndPassword(
          testEmail, testPass);
      result.fold(
        (l) => expect(l, const ServerFailure("fail")),
        (r) => null,
      );
    });
  });
  group('Sign In with Google', () {
    test('should return [AuthEntity] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signInWithGoogle())
          .thenAnswer((_) async => testModel);
      final result = await authRepositoryImpl.signInWithGoogle();
      result.fold(
        (l) => fail(l.message),
        (r) => expect(r, testModel.toEntity()),
      );
    });
    test('should return [ServerFailure] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signInWithGoogle())
          .thenThrow(ServerException("UserCredential not found."));
      final result = await authRepositoryImpl.signInWithGoogle();
      result.fold(
        (l) => expect(l, const ServerFailure("UserCredential not found.")),
        (r) => null,
      );
    });
  });
  group('Sign In', () {
    test('should return [void] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signInWithEmailAndPassword(
          testEmail, testPass)).thenAnswer((_) async => Right(voidVal));
      final result = await authRepositoryImpl.signInWithEmailAndPassword(
          testEmail, testPass);
      result.fold(
        (l) => fail(l.message),
        (_) => voidVal,
      );
    });
    test('should return [ServerFailure] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signInWithEmailAndPassword(
          testEmail, testPass)).thenThrow(ServerException("fail"));
      final result = await authRepositoryImpl.signInWithEmailAndPassword(
          testEmail, testPass);
      result.fold(
        (l) => expect(l, const ServerFailure("fail")),
        (_) => null,
      );
    });
  });
  group('Sign Out', () {
    test('should return [void] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signOut())
          .thenAnswer((_) async => Right(voidVal));
      final result = await authRepositoryImpl.signOut();
      result.fold(
        (l) => fail(l.message),
        (_) => voidVal,
      );
    });
    test('should return [ServerFailure] from datasource', () async {
      when(() => mockAuthRemoteDataSource.signOut())
          .thenThrow(ServerException("fail"));
      final result = await authRepositoryImpl.signOut();
      result.fold(
        (l) => expect(l, const ServerFailure("fail")),
        (_) => null,
      );
    });
  });
}
