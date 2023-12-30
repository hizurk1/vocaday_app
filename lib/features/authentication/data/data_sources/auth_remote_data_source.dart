import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/errors/exception.dart';
import '../models/auth_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Throw [FirebaseAuthException] for all Firebase errors
  /// Throw [ServerException] for unexpected errors
  Stream<User?> get user;
  Future<AuthModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<AuthModel> signInWithGoogle();
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl({required this.auth});

  @override
  Stream<User?> get user => auth.authStateChanges().map((user) => user);

  @override
  Future<AuthModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        throw ServerException("UserCredential not found.");
      }

      final providers =
          user.providerData.map((info) => info.providerId).toList();

      final authModel = AuthModel(
        uid: userCredential.user!.uid,
        user: user,
      ).copyWith(
        isNewUser: true,
        signInMethod:
            providers.contains("password") ? SignInMethod.email : null,
      );

      return authModel;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AuthModel> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user == null) {
          throw ServerException("UserCredential not found.");
        }

        final providers =
            user.providerData.map((info) => info.providerId).toList();

        final authModel = AuthModel(
          uid: user.uid,
          user: user,
        ).copyWith(
          isNewUser: userCredential.additionalUserInfo!.isNewUser,
          signInMethod:
              providers.contains("google.com") ? SignInMethod.google : null,
        );

        return authModel;
      } else {
        throw ServerException("GoogleSignInAccount not found.");
      }
    } on PlatformException catch (e) {
      throw ServerException(e.message ?? 'PlatformException');
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
