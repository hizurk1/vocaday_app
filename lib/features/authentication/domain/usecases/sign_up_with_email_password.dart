import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailPasswordUsecase
    extends Usecases<AuthEntity, (String, String)> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignUpWithEmailPasswordUsecase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  FutureEither<AuthEntity> call((String, String) params) async {
    final signUpResult =
        await authRepository.signUpWithEmailAndPassword(params.$1, params.$2);

    return await signUpResult.fold(
      (failure) async => Left(failure),
      (authEntity) async {
        if (!authEntity.isNewUser) {
          return Right(authEntity);
        }

        final user = authEntity.user;

        final userEntity = UserEntity(
          uid: authEntity.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          method: authEntity.signInMethod.name,
          avatar: user.photoURL,
          phone: user.phoneNumber,
          birthday: DateTime.now(),
          createdDate: user.metadata.creationTime,
        );

        final addUserResult = await userRepository.addUserProfile(userEntity);

        return addUserResult.fold(
          (fail) => Left(fail),
          (_) => Right(authEntity.copyWith(isNewUser: false)),
        );
      },
    );
  }
}
