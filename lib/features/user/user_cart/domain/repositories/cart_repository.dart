import '../../../../../core/typedef/typedefs.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  FutureEither<void> setCartBag(String uid, CartBagEntity cartBagEntity);
  FutureEither<CartEntity> getCart(String uid);
  FutureEither<void> updateCartBag(
      String uid, String id, CartBagEntity cartBagEntity);
  FutureEither<CartBagEntity> getCartBag(String uid, String id);
}
