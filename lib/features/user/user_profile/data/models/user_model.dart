import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends Equatable {
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

  const UserModel({
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

  UserModel copyWith({
    required String uid,
    String? name,
    String? email,
    String? method,
    String? avatar,
    String? phone,
    DateTime? birthday,
    String? gender,
    int point = 0,
    int gold = 0,
    List<DateTime>? attendance,
    DateTime? createdDate,
    List<String>? favourites,
    List<String>? knowns,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      method: method ?? this.method,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      point: point,
      gold: gold,
      attendance: attendance ?? attendance,
      createdDate: createdDate ?? this.createdDate,
      favourites: favourites ?? this.favourites,
      knowns: knowns ?? this.knowns,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      name: name,
      email: email,
      method: method,
      avatar: avatar,
      phone: phone,
      birthday: birthday,
      gender: gender,
      point: point,
      gold: gold,
      attendance: attendance,
      createdDate: createdDate,
      favourites: favourites,
      knowns: knowns,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      method: entity.method,
      avatar: entity.avatar,
      phone: entity.phone,
      birthday: entity.birthday,
      gender: entity.gender,
      point: entity.point,
      gold: entity.gold,
      attendance: entity.attendance,
      createdDate: entity.createdDate,
      favourites: entity.favourites,
      knowns: entity.knowns,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'method': method,
      'avatar': avatar,
      'phone': phone,
      'birthday': birthday?.millisecondsSinceEpoch,
      'gender': gender,
      'point': point,
      'gold': gold,
      'attendance': attendance?.map((x) => x.millisecondsSinceEpoch).toList(),
      'createdDate': createdDate?.millisecondsSinceEpoch,
      'favourites': favourites,
      'knowns': knowns,
    };
  }

  Map<String, dynamic> toMapUpdate() {
    return <String, dynamic>{
      'name': name,
      'avatar': avatar,
      'phone': phone,
      'birthday': birthday?.millisecondsSinceEpoch,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : '',
      method: map['method'] as String,
      avatar: map['avatar'],
      phone: map['phone'],
      birthday: map['birthday'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['birthday'] as int)
          : null,
      gender: map['gender'],
      point: map['point'] as int,
      gold: map['gold'] as int,
      attendance: map['attendance'] != null
          ? (map['attendance'] as List<dynamic>)
              .map<DateTime>(
                (x) => DateTime.fromMillisecondsSinceEpoch(
                    int.parse(x.toString())),
              )
              .toList()
          : null,
      createdDate: map['createdDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int)
          : null,
      favourites: map['favourites'] != null
          ? (map['favourites'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : null,
      knowns: map['knowns'] != null
          ? (map['knowns'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
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
