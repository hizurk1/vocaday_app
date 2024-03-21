import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;

  UserRepositoryImpl(this.userRemoteDataSource);

  @override
  FutureEither<void> addUserProfile(UserEntity userEntity) async {
    try {
      final userModel = UserModel.fromEntity(userEntity);
      return Right(
        await userRemoteDataSource.addUserProfile(
          uid: userModel.uid,
          map: userModel.toMap(),
        ),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: addUserProfile'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> getUserData(String uid) async* {
    yield* userRemoteDataSource.getUserData(uid).map((data) {
      if (data != null) {
        return UserModel.fromMap(data).toEntity();
      } else {
        return null;
      }
    });
  }

  @override
  FutureEither<void> updateUserProfile(UserEntity userEntity) async {
    try {
      final userModel = UserModel.fromEntity(userEntity);
      return Right(
        await userRemoteDataSource.updateUserProfile(
          uid: userModel.uid,
          map: userModel.toMapUpdate(),
        ),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: updateUserProfile'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<bool> addAttendanceDate({
    required String uid,
    required List<DateTime> attendance,
  }) async {
    try {
      return Right(
        await userRemoteDataSource.addAttendanceDate(
          uid: uid,
          map: {
            'attendance':
                attendance.map((x) => x.millisecondsSinceEpoch).toList(),
            'point': FieldValue.increment(AppValueConst.attendancePoint),
            'gold': FieldValue.increment(AppValueConst.attendanceGold),
          },
        ),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: addAttendanceDate'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<UserEntity>> getListUsers() async {
    try {
      final data = await userRemoteDataSource.getListUsers();
      final entities = data.map((map) => UserModel.fromMap(map).toEntity());

      return Right(entities.toList());
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: getListUsers'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<String>> syncFavourites({
    required String uid,
    required List<String> favourites,
  }) async {
    try {
      final res = await userRemoteDataSource.syncFavourites(
        uid: uid,
        map: {'favourites': favourites},
      );
      return Right(res);
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: syncFavourites'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> removeAllFavourites({required String uid}) async {
    try {
      return Right(
        await userRemoteDataSource.removeAllFavourites(uid: uid),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: removeAllFavourites'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> removeAllKnowns({required String uid}) async {
    try {
      return Right(
        await userRemoteDataSource.removeAllKnowns(uid: uid),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: removeAllKnowns'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<List<String>> syncKnowns({
    required String uid,
    required List<String> knowns,
  }) async {
    try {
      final res = await userRemoteDataSource.syncKnowns(
        uid: uid,
        map: {'knowns': knowns},
      );
      return Right(res);
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: syncKnowns'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> deleteUserProfile(String uid) async {
    try {
      return Right(await userRemoteDataSource.deleteUserProfile(uid: uid));
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: deleteUserProfile'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> addKnownWords({
    required String uid,
    required List<String> knowns,
  }) async {
    try {
      return Right(await userRemoteDataSource.addKnownWords(
        uid: uid,
        list: knowns,
      ));
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: addKnownWords'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
