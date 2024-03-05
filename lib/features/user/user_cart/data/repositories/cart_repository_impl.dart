import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/cart_remote_data_source.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  FutureEither<CartEntity> getCart(String uid) async {
    try {
      final data = await remoteDataSource.getCart(uid);
      final bags = data.map((map) => CartBagModel.fromMap(map)).toList();
      return Right(CartModel(bags: bags).toEntity());
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: getCart'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<CartBagEntity> getCartBag(String uid, String id) async {
    try {
      final data = await remoteDataSource.getCartBag(uid, id);
      if (data != null) {
        return Right(CartBagModel.fromMap(data).toEntity());
      } else {
        return const Left(
          FirebaseFailure(AppStringConst.objectNotFoundMessage),
        );
      }
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: getCartBag'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> setCartBag(
    String uid,
    CartBagEntity cartBagEntity,
  ) async {
    try {
      final map = CartBagModel.fromEntity(cartBagEntity).toMap();
      return Right(
        await remoteDataSource.setCartBag(uid, map),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: setCartBag'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  FutureEither<void> updateCartBag(
    String uid,
    String id,
    CartBagEntity cartBagEntity,
  ) async {
    try {
      final map = CartBagModel.fromEntity(cartBagEntity).toMap();
      return Right(
        await remoteDataSource.updateCartBag(uid, id, map),
      );
    } on FirebaseException catch (e) {
      return Left(
        FirebaseFailure(e.message ?? 'FirebaseFailure: updateCartBag'),
      );
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
