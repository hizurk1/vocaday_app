import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartBagUsecase
    extends Usecases<CartEntity, (String, CartEntity, CartBagEntity)> {
  final CartRepository repository;

  UpdateCartBagUsecase(this.repository);

  @override
  FutureEither<CartEntity> call(
      (String, CartEntity, CartBagEntity) params) async {
    final uid = params.$1;
    final cart = params.$2;
    final cartBag = params.$3;

    final updatedBags = cart.bags.map((e) {
      return e.dateTime.millisecondsSinceEpoch ==
              cartBag.dateTime.millisecondsSinceEpoch
          ? cartBag
          : e;
    }).toList();
    final newCart = cart.copyWith(bags: updatedBags);

    final result = await repository.updateCart(uid, newCart);
    return result.fold(
      (failure) => Left(failure),
      (_) => Right(newCart),
    );
  }
}
