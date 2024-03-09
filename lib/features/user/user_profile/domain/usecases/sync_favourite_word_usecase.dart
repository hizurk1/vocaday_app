import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class SyncFavouriteWordUsecase
    extends Usecases<List<String>, (String, List<String>)> {
  final UserRepository repository;

  SyncFavouriteWordUsecase({required this.repository});

  @override
  FutureEither<List<String>> call((String, List<String>) params) async {
    return await repository.syncFavourites(
      uid: params.$1,
      favourites: params.$2,
    );
  }
}
