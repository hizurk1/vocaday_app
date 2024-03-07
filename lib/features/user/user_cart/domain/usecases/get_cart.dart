import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUsecase extends Usecases<CartEntity, String> {
  final CartRepository repository;

  GetCartUsecase(this.repository);

  @override
  FutureEither<CartEntity> call(String params) async {
    final result = await repository.getCart(params);
    return result.fold(
      (fail) => Left(fail),
      (cart) => Right(CartEntity(
        id: cart.id,
        bags: cart.bags.reversed.toList(),
      )),
    );
  }
}
