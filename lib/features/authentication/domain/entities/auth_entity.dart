// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/auth_model.dart';

class AuthEntity extends Equatable {
  final String uid;
  final User user;
  final bool isNewUser;
  final SignInMethod signInMethod;

  const AuthEntity({
    required this.uid,
    required this.user,
    required this.isNewUser,
    required this.signInMethod,
  });

  AuthEntity copyWith({
    String? uid,
    User? user,
    bool? isNewUser,
    SignInMethod? signInMethod,
  }) {
    return AuthEntity(
      uid: uid ?? this.uid,
      user: user ?? this.user,
      isNewUser: isNewUser ?? this.isNewUser,
      signInMethod: signInMethod ?? this.signInMethod,
    );
  }

  @override
  List<Object?> get props => [uid, user, isNewUser, signInMethod];
}
