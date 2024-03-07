import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../../app/routes/route_manager.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/add_cart_bag.dart';
import '../../../domain/usecases/get_cart.dart';
import '../cart_bag/cart_bag_cubit.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddCartBagUsecase addCartBagUsecase;
  final GetCartUsecase getCartUsecase;
  final SharedPrefManager sharedPrefManager;
  CartCubit(
    this.addCartBagUsecase,
    this.getCartUsecase,
    this.sharedPrefManager,
  ) : super(const CartEmptyState());

  Future<void> getCart(String uid) async {
    emit(const CartLoadingState());

    final result = await getCartUsecase(uid);
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) => emit(CartLoadedState(cart)),
    );
  }

  Future<void> addCartBag(String uid) async {
    emit(const CartLoadingState());

    final cartBagLocal = sharedPrefManager.getCartBags;
    final result = await addCartBagUsecase((
      uid,
      CartBagEntity(
        words: cartBagLocal,
        dateTime: DateTime.now(),
      )
    ));
    result.fold(
      (failure) {
        Navigators()
            .showMessage(failure.message, type: MessageType.error, opacity: 1);
        emit(CartErrorState(failure.message));
      },
      (cart) {
        Navigators().currentContext!.read<CartBagCubit>().clearAllCartBag();
        Navigators().showMessage(
          LocaleKeys.cart_packed_your_cart_bag.tr(),
          type: MessageType.success,
          opacity: 1,
          actionText: LocaleKeys.common_view.tr(),
          duration: 5,
          onAction: () => Navigators().currentContext!.push(AppRoutes.cart),
        );
        emit(CartLoadedState(cart));
      },
    );
  }
}
