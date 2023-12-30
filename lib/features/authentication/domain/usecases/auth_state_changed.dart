import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class AuthStateChangedUsecase {
  final AuthRepository repository;

  AuthStateChangedUsecase({required this.repository});

  Stream<User?> get user => repository.user;
}
