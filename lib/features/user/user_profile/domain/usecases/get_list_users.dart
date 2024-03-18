import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetListUsersUsecase extends Usecases<List<UserEntity>, int> {
  final UserRepository repository;

  GetListUsersUsecase({required this.repository});

  @override
  FutureEither<List<UserEntity>> call(int params) {
    return repository.getListUsers(limit: params);
  }
}
