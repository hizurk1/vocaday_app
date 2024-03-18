import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../../../config/app_logger.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<User?> get user => remoteDataSource.user;

  @override
  FutureEither<AuthEntity> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final authModel =
          await remoteDataSource.signUpWithEmailAndPassword(email, password);
      return Right(authModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return Right(
        await remoteDataSource.signInWithEmailAndPassword(email, password),
      );
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<AuthEntity> signInWithGoogle() async {
    try {
      final authModel = await remoteDataSource.signInWithGoogle();
      return Right(authModel.toEntity());
    } on FirebaseAuthException catch (e) {
      logger.e(e.message, stackTrace: e.stackTrace);
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      logger.e(e.message);
      return Left(ServerFailure(e.message));
    } catch (e) {
      logger.e(e.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> signOut() async {
    try {
      return Right(await remoteDataSource.signOut());
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> reauthenticateWithCredential(
      String email, String password) async {
    try {
      return Right(
          await remoteDataSource.reauthenticateWithCredential(email, password));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> updatePassword(String password) async {
    try {
      return Right(await remoteDataSource.updatePassword(password));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> sendCodeToEmail(String email) async {
    try {
      return Right(await remoteDataSource.sendCodeToEmail(email));
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteUserAuth() async {
    try {
      return Right(await remoteDataSource.deleteUserAuth());
    } on FirebaseAuthException catch (e) {
      return Left(ServerFailure(e.message ?? e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
