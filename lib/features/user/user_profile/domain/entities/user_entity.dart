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
  final List<DateTime>? attendance;
  final DateTime? createdDate;
  final List<String>? favourites;
  final List<String>? knowns;

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
    this.attendance,
    this.createdDate,
    this.favourites,
    this.knowns,
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
    List<DateTime>? attendance,
    DateTime? createdDate,
    List<String>? favourites,
    List<String>? knowns,
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
      attendance: attendance ?? attendance,
      createdDate: createdDate ?? this.createdDate,
      favourites: favourites ?? this.favourites,
      knowns: knowns ?? this.knowns,
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
        attendance,
        createdDate,
        favourites,
        knowns,
      ];
}
