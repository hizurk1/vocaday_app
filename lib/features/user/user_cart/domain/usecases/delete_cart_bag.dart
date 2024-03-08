import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class DeleteCartBagUsecase
    extends Usecases<CartEntity, (String, CartEntity, CartBagEntity)> {
  final CartRepository repository;

  DeleteCartBagUsecase(this.repository);

  @override
  FutureEither<CartEntity> call(
      (String, CartEntity, CartBagEntity) params) async {
    final uid = params.$1;
    final cart = params.$2;
    final cartBag = params.$3;

    final bags = cart.bags..remove(cartBag);
    final newCartEntity = cart.copyWith(bags: bags);

    final result = await repository.updateCart(uid, newCartEntity);
    return result.fold(
      (failure) => Left(failure),
      (_) => Right(newCartEntity),
    );
  }
}
