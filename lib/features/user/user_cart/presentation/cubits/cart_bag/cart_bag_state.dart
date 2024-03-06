// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'cart_bag_cubit.dart';

enum CartBagStatus { empty, loading, loaded, error }

class CartBagState extends Equatable {
  CartBagState({
    required this.status,
    this.entity,
    this.message,
  });

  CartBagStatus status;
  CartBagEntity? entity;
  String? message;

  @override
  List<Object?> get props => [status, entity, message];

  CartBagState copyWith({
    CartBagStatus? status,
    CartBagEntity? entity,
    String? message,
  }) {
    return CartBagState(
      status: status ?? this.status,
      entity: entity ?? this.entity,
      message: message ?? this.message,
    );
  }
}
