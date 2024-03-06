import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/managers/shared_preferences.dart';
import '../../../domain/entities/cart_entity.dart';

part 'cart_bag_state.dart';

class CartBagCubit extends Cubit<CartBagState> {
  final SharedPrefManager sharedPrefManager;

  CartBagCubit(this.sharedPrefManager)
      : super(CartBagState(status: CartBagStatus.empty)) {
    getCartBag();
  }

  List<String> getCartBag() {
    emit(state.copyWith(status: CartBagStatus.loading));
    try {
      final localList = sharedPrefManager.getCartBags;
      emit(state.copyWith(
        status: CartBagStatus.loaded,
        entity: CartBagEntity(
          words: localList,
          dateTime: DateTime.now(),
        ),
      ));
      return localList;
    } on UnimplementedError catch (e) {
      emit(state.copyWith(
        status: CartBagStatus.error,
        message: e.message ?? '',
      ));
    }
    return [];
  }

  Future<void> addCartBag(String word) async {
    emit(state.copyWith(status: CartBagStatus.loading));
    try {
      final localList = sharedPrefManager.getCartBags;
      localList.add(word);
      await sharedPrefManager.setCartBags(localList);
      emit(state.copyWith(
        status: CartBagStatus.loaded,
        entity: CartBagEntity(
          words: localList,
          dateTime: DateTime.now(),
        ),
      ));
    } on UnimplementedError catch (e) {
      emit(state.copyWith(
        status: CartBagStatus.error,
        message: e.message ?? '',
      ));
    }
  }

  Future<void> removeCartBagItem(String word) async {
    emit(state.copyWith(status: CartBagStatus.loading));
    try {
      final localList = sharedPrefManager.getCartBags;
      localList.remove(word);
      await sharedPrefManager.setCartBags(localList);
      emit(state.copyWith(
        status: CartBagStatus.loaded,
        entity: CartBagEntity(
          words: localList,
          dateTime: DateTime.now(),
        ),
      ));
    } on UnimplementedError catch (e) {
      emit(state.copyWith(
        status: CartBagStatus.error,
        message: e.message ?? '',
      ));
    }
  }

  void searchCartBagItem(String input) {
    emit(state.copyWith(status: CartBagStatus.loading));
    try {
      final localList = sharedPrefManager.getCartBags;
      emit(state.copyWith(
        status: CartBagStatus.loaded,
        entity: CartBagEntity(
          words: localList
              .where((e) => e.toLowerCase().contains(input.toLowerCase()))
              .toList(),
          dateTime: DateTime.now(),
        ),
      ));
    } on UnimplementedError catch (e) {
      emit(state.copyWith(
        status: CartBagStatus.error,
        message: e.message ?? '',
      ));
    }
  }

  void clearAllCartBag() {
    emit(state.copyWith(status: CartBagStatus.loading));
    try {
      sharedPrefManager.removeLocalCartBags();
      emit(state.copyWith(
        status: CartBagStatus.loaded,
        entity: CartBagEntity(
          words: const [],
          dateTime: DateTime.now(),
        ),
      ));
    } on UnimplementedError catch (e) {
      emit(state.copyWith(
        status: CartBagStatus.error,
        message: e.message ?? '',
      ));
    }
  }
}
