import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddCartUsecase extends Usecases<void, (String, CartEntity)> {
  final CartRepository repository;

  AddCartUsecase(this.repository);

  @override
  FutureEither<void> call((String, CartEntity) params) async {
    return await repository.createCart(params.$1, params.$2);
  }
}
