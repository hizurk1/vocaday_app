import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/user_repository.dart';

class SyncKnownWordUsecase
    extends Usecases<List<String>, (String, List<String>)> {
  final UserRepository repository;

  SyncKnownWordUsecase(this.repository);

  @override
  FutureEither<List<String>> call((String, List<String>) params) async {
    return await repository.syncKnowns(
      uid: params.$1,
      knowns: params.$2,
    );
  }
}
