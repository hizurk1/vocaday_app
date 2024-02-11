// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String method;
  final String? avatar;
  final String? phone;
  final DateTime? birthday;
  final String? gender;
  final int point;
  final int gold;
  final List<DateTime>? checkIn;
  final DateTime? createdDate;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.method = "none",
    this.avatar,
    this.phone,
    this.birthday,
    this.gender,
    this.point = 0,
    this.gold = 0,
    this.checkIn,
    this.createdDate,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? method,
    String? avatar,
    String? phone,
    DateTime? birthday,
    String? gender,
    int? point,
    int? gold,
    List<DateTime>? checkIn,
    DateTime? createdDate,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      method: method ?? this.method,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      point: point ?? this.point,
      gold: gold ?? this.gold,
      checkIn: checkIn ?? this.checkIn,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        email,
        method,
        avatar,
        phone,
        birthday,
        gender,
        point,
        gold,
        checkIn,
        createdDate,
      ];
}
