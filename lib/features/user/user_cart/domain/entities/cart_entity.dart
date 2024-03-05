// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final List<CartBagEntity> bags;
  const CartEntity({
    required this.bags,
  });

  @override
  List<Object> get props => [bags];

  CartEntity copyWith({
    String? uid,
    List<CartBagEntity>? bags,
    int? limit,
  }) {
    return CartEntity(
      bags: bags ?? this.bags,
    );
  }
}

class CartBagEntity extends Equatable {
  final String uid;
  final List<String> words;
  final DateTime dateTime;
  const CartBagEntity({
    required this.uid,
    required this.words,
    required this.dateTime,
  });

  @override
  List<Object> get props => [uid, words, dateTime];

  CartBagEntity copyWith({
    String? uid,
    List<String>? words,
    DateTime? dateTime,
  }) {
    return CartBagEntity(
      uid: uid ?? this.uid,
      words: words ?? this.words,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
