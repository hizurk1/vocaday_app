import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase extends UsecasesNoParam<void> {
  final AuthRepository repository;
  final SharedPrefManager sharedPrefManager;

  SignOutUsecase(this.repository, this.sharedPrefManager);

  @override
  FutureEither<void> call() async {
    sharedPrefManager.clearAllFavouriteWords();
    sharedPrefManager.clearAllKnownWords();
    sharedPrefManager.removeLocalCartBags();
    return await repository.signOut();
  }
}
