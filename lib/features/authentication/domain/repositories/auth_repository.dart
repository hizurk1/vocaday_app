import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../entities/auth_entity.dart';

abstract interface class AuthRepository {
  Stream<User?> get user;
  FutureEither<AuthEntity> signUpWithEmailAndPassword(
      String email, String password);
  FutureEither<void> signInWithEmailAndPassword(String email, String password);
  FutureEither<AuthEntity> signInWithGoogle();
  FutureEither<void> signOut();
}
