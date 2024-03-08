// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_entity.dart';

class CartModel extends Equatable {
  final String id;
  final List<CartBagModel> bags;
  const CartModel({
    required this.id,
    required this.bags,
  });

  @override
  List<Object> get props => [id, bags];

  CartModel copyWith({
    String? id,
    List<CartBagModel>? bags,
  }) {
    return CartModel(
      id: id ?? this.id,
      bags: bags ?? this.bags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bags': bags.map((x) => x.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] as String,
      bags: List<CartBagModel>.from(
        (map['bags'] as List).map<CartBagModel>(
          (x) => CartBagModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      bags: bags.map((e) => e.toEntity()).toList(),
    );
  }

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      id: entity.id,
      bags: entity.bags.map((e) => CartBagModel.fromEntity(e)).toList(),
    );
  }
}

class CartBagModel extends Equatable {
  final String label;
  final List<String> words;
  final DateTime dateTime;
  const CartBagModel({
    required this.label,
    required this.words,
    required this.dateTime,
  });

  @override
  List<Object> get props => [label, words, dateTime];

  CartBagModel copyWith({
    String? label,
    List<String>? words,
    DateTime? dateTime,
  }) {
    return CartBagModel(
      label: label ?? this.label,
      words: words ?? this.words,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'words': words,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory CartBagModel.fromMap(Map<String, dynamic> map) {
    return CartBagModel(
      label: map['label'] as String,
      words: (map['words'] as List).map((e) => e.toString()).toList(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }

  CartBagEntity toEntity() {
    return CartBagEntity(label: label, words: words, dateTime: dateTime);
  }

  factory CartBagModel.fromEntity(CartBagEntity entity) {
    return CartBagModel(
      label: entity.label,
      words: entity.words,
      dateTime: entity.dateTime,
    );
  }
}
