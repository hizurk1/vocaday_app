import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../data/models/user_model.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetListUsersUsecase
    extends Usecases<List<UserEntity>, (FilterUserType, int)> {
  final UserRepository repository;

  GetListUsersUsecase({required this.repository});

  @override
  FutureEither<List<UserEntity>> call((FilterUserType, int) params) {
    return repository.getListUsers(type: params.$1, limit: params.$2);
  }
}
