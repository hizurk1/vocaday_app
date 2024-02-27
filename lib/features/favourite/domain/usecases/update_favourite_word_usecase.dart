import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../user/domain/repositories/user_repository.dart';

class UpdateFavouriteWordUsecase
    extends Usecases<List<String>, (String, List<String>)> {
  final UserRepository repository;

  UpdateFavouriteWordUsecase({required this.repository});

  @override
  FutureEither<List<String>> call((String, List<String>) params) async {
    return await repository.updateFavourites(
      uid: params.$1,
      favourites: params.$2,
    );
  }
}
