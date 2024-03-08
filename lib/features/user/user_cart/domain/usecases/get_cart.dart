import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUsecase extends Usecases<CartEntity, String> {
  final CartRepository repository;

  GetCartUsecase(this.repository);

  @override
  FutureEither<CartEntity> call(String params) async {
    return await repository.getCart(params);
  }
}
