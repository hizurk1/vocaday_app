import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class AddUserProfile extends Usecases<void, UserEntity> {
  final UserRepository repository;

  AddUserProfile({required this.repository});

  @override
  FutureEither<void> call(UserEntity params) async {
    return await repository.addUserProfile(params);
  }
}
