import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/exception.dart';
import '../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<void> addUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<void> deleteUserProfile({required String uid});

  Stream<Map<String, dynamic>?> getUserData(String uid);

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<bool> addAttendanceDate({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<List<Map<String, dynamic>>> getListUsers();

  Future<List<String>> syncFavourites({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<List<String>> syncKnowns({
    required String uid,
    required Map<String, dynamic> map,
  });

  Future<void> addKnownWords({
    required String uid,
    required List<String> list,
  });

  Future<void> removeAllFavourites({required String uid});

  Future<void> removeAllKnowns({required String uid});
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
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
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
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
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
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getListUsers() async {
    try {
      final snapshots = await firestore.collection(_users).get();
      return snapshots.docs.map((e) => e.data()).toList();
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<List<String>> syncFavourites({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      List<String> localList = map['favourites'] as List<String>;
      if (localList.isEmpty) {
        final res = await firestore.collection(_users).doc(uid).get();
        localList = UserModel.fromMap(res.data()!).favourites ?? [];
      } else {
        await firestore.collection(_users).doc(uid).update(map);
      }

      return localList;
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> removeAllFavourites({required String uid}) async {
    try {
      await firestore.collection(_users).doc(uid).update({'favourites': null});
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> removeAllKnowns({required String uid}) async {
    try {
      await firestore.collection(_users).doc(uid).update({'knowns': null});
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<List<String>> syncKnowns({
    required String uid,
    required Map<String, dynamic> map,
  }) async {
    try {
      List<String> localList = map['knowns'] as List<String>;
      if (localList.isEmpty) {
        final res = await firestore.collection(_users).doc(uid).get();
        localList = UserModel.fromMap(res.data()!).knowns ?? [];
      } else {
        await firestore.collection(_users).doc(uid).update(map);
      }

      return localList;
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> deleteUserProfile({required String uid}) async {
    try {
      await firestore.collection(_users).doc(uid).delete();
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> addKnownWords({
    required String uid,
    required List<String> list,
  }) async {
    try {
      await firestore.collection(_users).doc(uid).update({
        'knowns': FieldValue.arrayUnion(list),
      });
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }
}
