import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserDataUsecase {
  final UserRepository repository;

  GetUserDataUsecase({required this.repository});

  Stream<UserEntity?> call(String uid) {
    return repository.getUserData(uid);
  }
}
