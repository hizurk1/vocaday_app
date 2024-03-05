import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/errors/exception.dart';

abstract class CartRemoteDataSource {
  Future<void> setCartBag(String uid, Map<String, dynamic> map);
  Future<List<Map<String, dynamic>>> getCart(String uid);
  Future<void> updateCartBag(String uid, String id, Map<String, dynamic> map);
  Future<Map<String, dynamic>?> getCartBag(String uid, String id);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> setCartBag(
    String uid,
    Map<String, dynamic> map,
  ) async {
    try {
      final bagId = firestore.collection("users/$uid/cart").id;
      await firestore.collection("users/$uid/cart").doc(bagId).set(map);
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCart(String uid) async {
    try {
      final snapshots = await firestore.collection("users/$uid/cart").get();
      return snapshots.docs.map((doc) => doc.data()).toList();
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<void> updateCartBag(
    String uid,
    String id,
    Map<String, dynamic> map,
  ) async {
    try {
      await firestore.collection("users/$uid/cart").doc(id).update(map);
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCartBag(String uid, String id) async {
    try {
      final snapshot =
          await firestore.collection("users/$uid/cart").doc(id).get();
      return snapshot.data();
    } on FirebaseException {
      rethrow;
    } on UnimplementedError catch (e) {
      throw DatabaseException(e.message ?? '');
    }
  }
}
