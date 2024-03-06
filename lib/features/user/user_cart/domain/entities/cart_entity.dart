// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String uid;
  final List<CartBagEntity> bags;
  const CartEntity({
    required this.uid,
    required this.bags,
  });

  static CartEntity get empty => const CartEntity(
        uid: '',
        bags: [],
      );

  @override
  List<Object> get props => [uid, bags];

  CartEntity copyWith({
    String? uid,
    List<CartBagEntity>? bags,
  }) {
    return CartEntity(
      uid: uid ?? this.uid,
      bags: bags ?? this.bags,
    );
  }
}

class CartBagEntity extends Equatable {
  final List<String> words;
  final DateTime dateTime;
  const CartBagEntity({
    required this.words,
    required this.dateTime,
  });

  @override
  List<Object> get props => [words, dateTime];

  CartBagEntity copyWith({
    List<String>? words,
    DateTime? dateTime,
  }) {
    return CartBagEntity(
      words: words ?? this.words,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
