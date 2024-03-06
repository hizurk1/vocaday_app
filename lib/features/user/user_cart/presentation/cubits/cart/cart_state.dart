part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartEmptyState extends CartState {
  const CartEmptyState();
}

final class CartLoadingState extends CartState {
  const CartLoadingState();
}

final class CartLoadedState extends CartState {
  final CartEntity entity;

  const CartLoadedState(this.entity);

  @override
  List<Object> get props => [entity];
}

final class CartErrorState extends CartState {
  final String message;

  const CartErrorState(this.message);
  @override
  List<Object> get props => [message];
}
