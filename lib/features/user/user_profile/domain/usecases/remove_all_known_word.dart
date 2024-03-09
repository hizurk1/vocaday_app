import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class RemoveAllKnownWordUsecase extends Usecases<void, String> {
  final UserRepository repository;

  RemoveAllKnownWordUsecase(this.repository);

  @override
  FutureEither<void> call(String params) async {
    return await repository.removeAllKnowns(uid: params);
  }
}
