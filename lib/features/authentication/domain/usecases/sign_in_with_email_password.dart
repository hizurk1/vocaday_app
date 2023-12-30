import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailPasswordUsecase extends Usecases<void, (String, String)> {
  final AuthRepository repository;

  SignInWithEmailPasswordUsecase({required this.repository});

  @override
  FutureEither<void> call((String, String) params) async {
    return await repository.signInWithEmailAndPassword(params.$1, params.$2);
  }
}
