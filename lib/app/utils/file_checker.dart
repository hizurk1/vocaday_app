import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/errors/failure.dart';

class FileChecker {
  Either<Failure, XFile> checkImage(XFile? file) {
    return file != null
        ? Right(file)
        : const Left(NoFileFailure('No file selected!'));
  }
}
