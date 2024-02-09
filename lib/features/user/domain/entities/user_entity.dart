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
