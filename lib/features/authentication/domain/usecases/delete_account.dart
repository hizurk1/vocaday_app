import 'package:fpdart/fpdart.dart';

import '../../../../app/managers/cloud_storage.dart';
import '../../../../app/managers/shared_preferences.dart';
import '../../../../core/typedef/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../user/user_cart/domain/repositories/cart_repository.dart';
import '../../../user/user_profile/domain/repositories/user_repository.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUsecase extends Usecases<void, String> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final CartRepository _cartRepository;
  final SharedPrefManager _sharedPrefManager;
  final CloudStorageService _cloudStorageService;

  DeleteAccountUsecase(
    this._authRepository,
    this._userRepository,
    this._cartRepository,
    this._sharedPrefManager,
    this._cloudStorageService,
  );

  @override
  FutureEither<void> call(String params) async {
    final deleteStorage = await _cloudStorageService.deleteUserAvatar(params);

    return await deleteStorage.fold(
      (failure) async => Left(failure),
      (_) async {
        final deleteCart = await _cartRepository.deleteCart(params);

        return await deleteCart.fold(
          (failure) async => Left(failure),
          (_) async {
            final deleteProfile =
                await _userRepository.deleteUserProfile(params);

            return await deleteProfile.fold(
              (failure) async => Left(failure),
              (_) async {
                _sharedPrefManager.clearAllKnownWords();
                _sharedPrefManager.clearAllFavouriteWords();
                _sharedPrefManager.removeLocalCartBags();

                return await _authRepository.deleteUserAuth();
              },
            );
          },
        );
      },
    );
  }
}
