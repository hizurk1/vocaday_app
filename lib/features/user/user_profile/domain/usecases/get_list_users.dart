import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetListUsersUsecase extends UsecasesNoParam<List<UserEntity>> {
  final UserRepository repository;

  GetListUsersUsecase({required this.repository});

  @override
  FutureEither<List<UserEntity>> call() async {
    return await repository.getListUsers();
  }
}
