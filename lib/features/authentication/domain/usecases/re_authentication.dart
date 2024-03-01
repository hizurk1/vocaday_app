import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class ReAuthenticationUsecase extends Usecases<void, (String, String)> {
  final AuthRepository repository;

  ReAuthenticationUsecase(this.repository);

  @override
  FutureEither<void> call((String, String) params) async {
    final email = params.$1;
    final currentPassword = params.$2;
    return await repository.reauthenticateWithCredential(
      email,
      currentPassword,
    );
  }
}
