import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/errors/exception.dart';
import '../../../../config/app_logger.dart';
import '../models/auth_model.dart';

abstract interface class AuthRemoteDataSource {
  /// Throw [FirebaseAuthException] for all Firebase errors
  /// Throw [ServerException] for unexpected errors
  Stream<User?> get user;
  Future<AuthModel> signUpWithEmailAndPassword(String email, String password);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<AuthModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> updatePassword(String password);
  Future<void> reauthenticateWithCredential(String email, String password);
  Future<void> sendCodeToEmail(String email);
  Future<void> deleteUserAuth();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;

  AuthRemoteDataSourceImpl(this._auth);

  @override
  Stream<User?> get user => _auth.authStateChanges();

  @override
  Future<AuthModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
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
      await _auth.signInWithEmailAndPassword(
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
            await _auth.signInWithCredential(credential);

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
        logger.e("Cancel Google sign in form.");
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
      await _auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> reauthenticateWithCredential(
      String email, String password) async {
    try {
      await _auth.currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: email,
          password: password,
        ),
      );
    } on FirebaseAuthException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw ServerException(e.message ?? 'reauthenticateWithCredential');
    }
  }

  @override
  Future<void> updatePassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);
    } on FirebaseAuthException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw ServerException(e.message ?? 'reauthenticateWithCredential');
    }
  }

  @override
  Future<void> sendCodeToEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw ServerException(e.message ?? 'sendCodeToEmail');
    }
  }

  @override
  Future<void> deleteUserAuth() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw ServerException(e.message ?? 'deleteUserAuth');
    }
  }
}
