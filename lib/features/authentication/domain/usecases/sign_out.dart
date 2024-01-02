import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class SignOutUsecase extends UsecasesNoParam<void> {
  final AuthRepository repository;

  SignOutUsecase({required this.repository});

  @override
  FutureEither<void> call() => repository.signOut();
}
