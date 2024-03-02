import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase extends UsecasesNoParam<void> {
  final AuthRepository repository;

  SignOutUsecase({required this.repository});

  @override
  FutureEither<void> call() async {
    sl<SharedPrefManager>().clearAllFavouriteWords();
    return await repository.signOut();
  }
}
