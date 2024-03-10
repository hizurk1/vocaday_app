import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/game_repository.dart';

class UpdateUserGoldUsecase extends Usecases<void, (String, int)> {
  final GameRepository _repository;

  UpdateUserGoldUsecase(this._repository);

  @override
  FutureEither<void> call((String, int) params) async {
    return await _repository.updateUserGold(params.$1, params.$2);
  }
}
