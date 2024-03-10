import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/game_repository.dart';

class UpdateUserPointUsecase extends Usecases<void, (String, int)> {
  final GameRepository repository;

  UpdateUserPointUsecase(this.repository);

  @override
  FutureEither<void> call((String, int) params) async {
    return await repository.updateUserPoint(params.$1, params.$2);
  }
}
