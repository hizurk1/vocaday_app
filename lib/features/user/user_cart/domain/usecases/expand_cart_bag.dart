import 'package:fpdart/fpdart.dart';

import '../../../../../app/managers/shared_preferences.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class ExpandCartBagUsecase
    extends Usecases<CartEntity, (String, CartEntity, CartBagEntity)> {
  final CartRepository repository;
  final SharedPrefManager sharedPrefManager;

  ExpandCartBagUsecase(this.repository, this.sharedPrefManager);

  @override
  FutureEither<CartEntity> call(
      (String, CartEntity, CartBagEntity) params) async {
    final uid = params.$1;
    final cart = params.$2;
    final cartBag = params.$3;

    final bags = cart.bags..remove(cartBag);
    final newCartEntity = cart.copyWith(bags: bags);

    final result = await repository.updateCart(uid, newCartEntity);
    return await result.fold(
      (failure) => Left(failure),
      (_) async {
        //? Execute to update local bag
        Set<String> newBag = sharedPrefManager.getCartBags.toSet();
        newBag.addAll(cartBag.words);
        await sharedPrefManager.setCartBags(newBag.toList());

        return Right(newCartEntity);
      },
    );
  }
}
