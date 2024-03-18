import '../../../../../core/typedef/typedefs.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  FutureEither<void> createCart(String uid, CartEntity entity);
  FutureEither<CartEntity> getCart(String uid);
  FutureEither<void> updateCart(String uid, CartEntity entity);
  FutureEither<void> deleteCart(String uid);
}
