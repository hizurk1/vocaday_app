import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  ImagePickerUtil._init();
  static final ImagePickerUtil _instance = ImagePickerUtil._init();
  factory ImagePickerUtil() => _instance;

  final _picker = ImagePicker();

  Future<XFile?> pickImage({
    ImageSource? source,
    double? maxWidth,
    double? maxHeight,
    CameraDevice? preferredCameraDevice,
  }) async {
    return _picker.pickImage(
      source: source ?? ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredCameraDevice: preferredCameraDevice ?? CameraDevice.rear,
    );
  }
}
