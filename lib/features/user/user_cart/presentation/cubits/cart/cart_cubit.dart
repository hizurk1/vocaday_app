import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../app/managers/navigation.dart';
import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../../app/routes/route_manager.dart';
import '../../../../../../app/translations/translations.dart';
import '../../../../../../core/extensions/string.dart';
import '../../../../../word/domain/entities/word_entity.dart';
import '../../../domain/entities/cart_entity.dart';
import '../../../domain/usecases/add_cart_bag.dart';
import '../../../domain/usecases/delete_cart_bag.dart';
import '../../../domain/usecases/expand_cart_bag.dart';
import '../../../domain/usecases/get_cart.dart';
import '../../../domain/usecases/update_cart_bag.dart';
import '../cart_bag/cart_bag_cubit.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddCartBagUsecase addCartBagUsecase;
  final GetCartUsecase getCartUsecase;
  final DeleteCartBagUsecase deleteCartBagUsecase;
  final UpdateCartBagUsecase updateCartBagUsecase;
  final ExpandCartBagUsecase expandCartBagUsecase;
  final SharedPrefManager sharedPrefManager;
  CartCubit(
    this.addCartBagUsecase,
    this.getCartUsecase,
    this.deleteCartBagUsecase,
    this.updateCartBagUsecase,
    this.expandCartBagUsecase,
    this.sharedPrefManager,
  ) : super(const CartEmptyState());

  Future<void> renameCartBag(
    String uid,
    String name,
    CartEntity cartEntity,
    CartBagEntity cartBagEntity,
  ) async {
    emit(const CartLoadingState());

    final newCartBag = cartBagEntity.copyWith(label: name);
    final result = await updateCartBagUsecase((uid, cartEntity, newCartBag));
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) {
        Navigators().showMessage(LocaleKeys.cart_word_bag_update_success.tr(),
            type: MessageType.success);
        emit(CartLoadedState(cart));
      },
    );
  }

  Future<void> expandCartBag(
    String uid,
    CartEntity cartEntity,
    CartBagEntity cartBagEntity,
  ) async {
    emit(const CartLoadingState());

    final result = await expandCartBagUsecase((uid, cartEntity, cartBagEntity));
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) {
        Navigators().showMessage(
          LocaleKeys.cart_expand_bag_message.tr(
            args: [LocaleKeys.activity_word.plural(cartBagEntity.words.length)],
          ).fixBreakLine,
          duration: 8,
          type: MessageType.success,
          actionText: LocaleKeys.common_go.tr(),
          onAction: () =>
              Navigators().currentContext!.pushReplacement(AppRoutes.listWord),
        );
        emit(CartLoadedState(cart));
      },
    );
  }

  Future<void> deleteWordItem(
    String uid,
    WordEntity wordEntity,
    CartEntity cartEntity,
    CartBagEntity cartBagEntity,
  ) async {
    emit(const CartLoadingState());

    final wordItems = List<String>.from(cartBagEntity.words)
      ..remove(wordEntity.word);
    final newCartBag = cartBagEntity.copyWith(words: wordItems);
    final result = await updateCartBagUsecase((uid, cartEntity, newCartBag));
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) {
        Navigators().showMessage(LocaleKeys.cart_word_bag_update_success.tr(),
            type: MessageType.success);
        emit(CartLoadedState(cart));
      },
    );
  }

  Future<void> deleteCartBag(
    String uid,
    CartEntity cartEntity,
    CartBagEntity cartBagEntity,
  ) async {
    emit(const CartLoadingState());

    final result = await deleteCartBagUsecase((uid, cartEntity, cartBagEntity));
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) {
        Navigators().showMessage(LocaleKeys.cart_remove_cart_bag_success.tr(),
            type: MessageType.success);
        emit(CartLoadedState(cart));
      },
    );
  }

  Future<void> getCart(String uid) async {
    emit(const CartLoadingState());

    final result = await getCartUsecase(uid);
    result.fold(
      (failure) => emit(CartErrorState(failure.message)),
      (cart) => emit(CartLoadedState(cart)),
    );
  }

  Future<void> addCartBag(String uid, String label) async {
    emit(const CartLoadingState());

    final cartBagLocal = sharedPrefManager.getCartBags;
    final result = await addCartBagUsecase((
      uid,
      CartBagEntity(
        label: label,
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
