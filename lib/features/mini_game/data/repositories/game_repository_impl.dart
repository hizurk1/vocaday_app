import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/typedef/typedefs.dart';
import '../../domain/repositories/game_repository.dart';
import '../data_sources/game_remote_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource _remoteDataSource;

  GameRepositoryImpl(this._remoteDataSource);

  @override
  FutureEither<void> updateUserPoint(String uid, int point) async {
    try {
      return Right(
        await _remoteDataSource.updateUserPoint(uid, {
          'point': FieldValue.increment(point),
        }),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: updateUserPoint'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> updateUserGold(String uid, int gold) async {
    try {
      return Right(
        await _remoteDataSource.updateUserGold(uid, {
          'gold': FieldValue.increment(gold),
        }),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: updateUserGold'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
