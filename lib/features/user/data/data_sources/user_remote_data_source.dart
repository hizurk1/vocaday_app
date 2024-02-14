import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/exception.dart';
import '../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<void> addUserProfile(UserModel userModel);
  Stream<UserModel?> getUserData(String uid);
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _users = "users";
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addUserProfile(UserModel userModel) async {
    try {
      await firestore.collection(_users).doc(userModel.uid).set(
            userModel.toMap(),
            SetOptions(merge: true),
          );
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<UserModel?> getUserData(String uid) async* {
    yield* firestore.collection(_users).doc(uid).snapshots().map(
          (snapshot) => snapshot.data() != null
              ? UserModel.fromMap(snapshot.data()!)
              : null,
        );
  }

  @override
  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      await firestore.collection(_users).doc(uid).update(map);
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
