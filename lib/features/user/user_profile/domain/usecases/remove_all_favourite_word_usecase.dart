import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class RemoveAllFavouriteWordUsecase extends Usecases<void, String> {
  final UserRepository repository;

  RemoveAllFavouriteWordUsecase(this.repository);

  @override
  FutureEither<void> call(String params) async {
    return await repository.removeAllFavourites(uid: params);
  }
}
