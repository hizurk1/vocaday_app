import '../../../../core/typedef/typedefs.dart';

abstract class GameRepository {
  FutureEither<void> updateUserPoint(String uid, int point);
  FutureEither<void> updateUserGold(String uid, int gold);
}
