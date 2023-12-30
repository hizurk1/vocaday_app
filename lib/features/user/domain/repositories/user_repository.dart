import '../../../../../core/typedef/typedefs.dart';
import '../entities/user_entity.dart';

abstract interface class UserRepository {
  FutureEither<void> addUserProfile(UserEntity userEntity);
  Stream<UserEntity?> getUserData(String uid);
  FutureEither<void> updateUserProfile(UserEntity userEntity);
}
