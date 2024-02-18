import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/exception.dart';

abstract interface class UserRemoteDataSource {
  Future<void> addUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  });

  Stream<Map<String, dynamic>?> getUserData(String uid);

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<bool> addAttendanceDate({
    required String uid,
    required Map<String, dynamic> map,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _users = "users";
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      await firestore.collection(_users).doc(uid).set(
            map,
            SetOptions(merge: true),
          );
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>?> getUserData(String uid) async* {
    yield* firestore.collection(_users).doc(uid).snapshots().map(
          (snapshot) => snapshot.data(),
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

  @override
  Future<bool> addAttendanceDate({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      await firestore.collection(_users).doc(uid).update(map);
      return true;
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
