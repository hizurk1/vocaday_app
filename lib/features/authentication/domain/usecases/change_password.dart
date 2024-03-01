import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class ChangePasswordUsecase extends Usecases<void, String> {
  final AuthRepository repository;

  ChangePasswordUsecase(this.repository);

  @override
  FutureEither<void> call(String params) async {
    return await repository.updatePassword(params);
  }
}
