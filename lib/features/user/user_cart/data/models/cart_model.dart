// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

class CartModel extends Equatable {
  final String uid;
  final List<CartBagModel> bags;
  const CartModel({
    required this.uid,
    required this.bags,
  });

  @override
  List<Object> get props => [uid, bags];

  CartModel copyWith({
    String? uid,
    List<CartBagModel>? bags,
  }) {
    return CartModel(
      uid: uid ?? this.uid,
      bags: bags ?? this.bags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'bags': bags.map((x) => x.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      uid: map['uid'] as String,
      bags: List<CartBagModel>.from(
        (map['bags'] as List).map<CartBagModel>(
          (x) => CartBagModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      uid: uid,
      bags: bags.map((e) => e.toEntity()).toList(),
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      uid: entity.uid,
      bags: entity.bags.map((e) => CartBagModel.fromEntity(e)).toList(),
    );
  }
}

class CartBagModel extends Equatable {
  final List<String> words;
  final DateTime dateTime;
  const CartBagModel({
    required this.words,
    required this.dateTime,
  });

  @override
  List<Object> get props => [words, dateTime];

  CartBagModel copyWith({
    List<String>? words,
    DateTime? dateTime,
  }) {
    return CartBagModel(
      words: words ?? this.words,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'words': words,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory CartBagModel.fromMap(Map<String, dynamic> map) {
    return CartBagModel(
      words: (map['words'] as List).map((e) => e.toString()).toList(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  CartBagEntity toEntity() {
    return CartBagEntity(words: words, dateTime: dateTime);
  }

  factory CartBagModel.fromEntity(CartBagEntity entity) {
    return CartBagModel(
      words: entity.words,
      dateTime: entity.dateTime,
    );
  }
}
