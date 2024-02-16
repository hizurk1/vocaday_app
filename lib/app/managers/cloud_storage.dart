import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/errors/failure.dart';
import '../../core/typedef/typedefs.dart';

class CloudStorageService {
  final FirebaseStorage _storage;

  CloudStorageService(this._storage);

  String _getFolderAvatar(String uid) => 'users/$uid/avatar';

  FutureEither<bool> deleteUserAvatar(String uid) async {
    try {
      final avatarRef = _storage.ref().child(_getFolderAvatar(uid));
      final listResult = await avatarRef.listAll();

      for (final ref in listResult.items) {
        await ref.delete();
      }
      return const Right(true);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message ?? 'deleteUserAvatar'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Returns Failure | String url (avatar image url)
  FutureEither<String> uploadUserAvatarImage({
    required String uid,
    required String filePath,
    required String fileName,
    required String fileType,
  }) async {
    try {
      final imageRef =
          _storage.ref().child(_getFolderAvatar(uid)).child(fileName);

      await imageRef.putFile(
        File(filePath),
        SettableMetadata(contentType: fileType),
      );

      String url = await imageRef.getDownloadURL();

      return Right(url);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message ?? 'uploadUserAvatarImage'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
