import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddCartBagUsecase extends Usecases<CartEntity, (String, CartBagEntity)> {
  final CartRepository repository;

  AddCartBagUsecase(this.repository);

  @override
  FutureEither<CartEntity> call((String, CartBagEntity) params) async {
    final uid = params.$1;
    final cartBag = params.$2;

    final cartRes = await repository.getCart(uid);
    return await cartRes.fold(
      (failure) => Left(failure),
      (cartEntity) async {
        List<CartBagEntity> bags = cartEntity.bags;
        bags.add(cartBag);
        final cart = cartEntity.copyWith(bags: bags);
        final res = await repository.updateCart(uid, cart);
        return res.fold(
          (l) => Left(l),
          (_) => Right(cart),
        );
      },
    );
  }
}
