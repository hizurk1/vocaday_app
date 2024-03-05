import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../../app/managers/cloud_storage.dart';
import '../../../../../core/extensions/string.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../../injection_container.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class UpdateUserProfileUsecase extends Usecases<void, (UserEntity, XFile?)> {
  final UserRepository repository;

  UpdateUserProfileUsecase({required this.repository});

  @override
  FutureEither<void> call((UserEntity, XFile?) params) async {
    final UserEntity entity = params.$1;
    final String? filePath = params.$2?.path;

    if (filePath.isNullOrEmpty) {
      return await repository.updateUserProfile(entity);
    } else {
      final fileName = entity.uid;
      final fileExt = path.extension(filePath!);
      final uploadRes = await sl<CloudStorageService>().uploadUserAvatarImage(
        uid: entity.uid,
        filePath: filePath,
        fileName: "$fileName$fileExt",
        fileType: "image/${fileExt.substring(1)}",
      );

      return uploadRes.fold(
        (failure) => Left(failure),
        (imgUrl) async {
          final updateEntity = entity.copyWith(avatar: imgUrl);
          return await repository.updateUserProfile(updateEntity);
        },
      );
    }
  }
}
