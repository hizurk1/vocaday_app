import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/utils/util_functions.dart';
import '../../../user/user_cart/domain/entities/cart_entity.dart';
import '../../../user/user_cart/domain/repositories/cart_repository.dart';
import '../../../user/user_profile/domain/entities/user_entity.dart';
import '../../../user/user_profile/domain/repositories/user_repository.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpWithEmailPasswordUsecase
    extends Usecases<AuthEntity, (String, String)> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final CartRepository cartRepository;

  SignUpWithEmailPasswordUsecase({
    required this.authRepository,
    required this.userRepository,
    required this.cartRepository,
  });

  @override
  FutureEither<AuthEntity> call((String, String) params) async {
    final signUpResult =
        await authRepository.signUpWithEmailAndPassword(params.$1, params.$2);

    return signUpResult.fold(
      (failure) async => Left(failure),
      (authEntity) async {
        if (!authEntity.isNewUser) {
          return Right(authEntity);
        }

        final user = authEntity.user;

        final userEntity = UserEntity(
          uid: authEntity.uid,
          name: user.displayName ?? UtilFunction.splitFirst(user.email, '@'),
          email: user.email ?? '',
          method: authEntity.signInMethod.name,
          avatar: user.photoURL,
          phone: user.phoneNumber,
          birthday: DateTime.now(),
          createdDate: user.metadata.creationTime,
        );

        final addUserResult = await userRepository.addUserProfile(userEntity);

        return await addUserResult.fold(
          (fail) => Left(fail),
          (_) async {
            final addCartRes = await cartRepository.createCart(
              authEntity.uid,
              CartEntity.empty.copyWith(id: authEntity.uid),
            );

            return addCartRes.fold(
              (fail) => Left(fail),
              (_) => Right(authEntity.copyWith(isNewUser: false)),
            );
          },
        );
      },
    );
  }
}
