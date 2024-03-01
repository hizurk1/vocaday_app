import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class SendCodeToEmailUsecase extends Usecases<void, String> {
  final AuthRepository repository;

  SendCodeToEmailUsecase(this.repository);

  @override
  FutureEither<void> call(String params) async {
    return await repository.sendCodeToEmail(params);
  }
}
