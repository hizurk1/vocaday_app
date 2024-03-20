import '../../../../../app/managers/shared_preferences.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class AddKnownWordsUsecase extends Usecases<void, (String, List<String>)> {
  final UserRepository _repository;
  final SharedPrefManager _sharedPrefManager;

  AddKnownWordsUsecase(this._repository, this._sharedPrefManager);

  @override
  FutureEither<void> call((String, List<String>) params) async {
    await _sharedPrefManager.addKnownWordList(params.$2);
    return await _repository.addKnownWords(uid: params.$1, knowns: params.$2);
  }
}
