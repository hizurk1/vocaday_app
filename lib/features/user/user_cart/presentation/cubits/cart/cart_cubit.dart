import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../config/app_logger.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/add_cart_bag.dart';
import '../cart_bag/cart_bag_cubit.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddCartBagUsecase addCartBagUsecase;
  final SharedPrefManager sharedPrefManager;
  CartCubit(
    this.addCartBagUsecase,
    this.sharedPrefManager,
  ) : super(const CartEmptyState());

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
          onAction: () {
            logger.i("CartCubit.addCartBag");
          },
        );
        emit(CartLoadedState(cart));
      },
    );
  }
}
