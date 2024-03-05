// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

class CartModel extends Equatable {
  final List<CartBagModel> bags;
  const CartModel({
    required this.bags,
  });

  @override
  List<Object> get props => [bags];

  CartModel copyWith({
    List<CartBagModel>? bags,
  }) {
    return CartModel(
      bags: bags ?? this.bags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bags': bags.map((x) => x.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      bags: List<CartBagModel>.from(
        (map['bags'] as List).map<CartBagModel>(
          (x) => CartBagModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      bags: bags.map((e) => e.toEntity()).toList(),
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      bags: entity.bags.map((e) => CartBagModel.fromEntity(e)).toList(),
    );
  }
}

class CartBagModel extends Equatable {
  final String uid;
  final List<String> words;
  final DateTime dateTime;
  const CartBagModel({
    required this.uid,
    required this.words,
    required this.dateTime,
  });

  @override
  List<Object> get props => [uid, words, dateTime];

  CartBagModel copyWith({
    String? uid,
    List<String>? words,
    DateTime? dateTime,
  }) {
    return CartBagModel(
      uid: uid ?? this.uid,
      words: words ?? this.words,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'words': words,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory CartBagModel.fromMap(Map<String, dynamic> map) {
    return CartBagModel(
      uid: map['uid'] as String,
      words: (map['words'] as List).map((e) => e.toString()).toList(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(int.parse(map['dateTime'])),
    );
  }

  CartBagEntity toEntity() {
    return CartBagEntity(uid: uid, words: words, dateTime: dateTime);
  }

  factory CartBagModel.fromEntity(CartBagEntity entity) {
    return CartBagModel(
      uid: entity.uid,
      words: entity.words,
      dateTime: entity.dateTime,
    );
  }
}
