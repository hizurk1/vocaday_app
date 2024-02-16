class AppValueConst {
  AppValueConst._();

  /// In byte (~5MB).
  ///
  /// Convert to MB: maxImgUploadSize / 1024 / 1024
  static const maxImgUploadSize = 5242880;
  static const maxItemLoad = 50;
}

class AppStringConst {
  AppStringConst._();
  // Error message
  static const unexpectedErrorMessage = 'Unexpected Error';
  static const serverFailureMessage = 'Server failure';
  static const cacheFailureMessage = 'Cache failure';
  static const invalidInputFailureMessage =
      'Invalid input - The number must be a positive integer or zero.';
  static const noImageSelectedMessage = 'No image selected.';
  static const noFileSelectedMessage = 'No file selected.';
  static const objectNotFoundMessage = 'Object not found.';
}

class AppPrefsKey {
  AppPrefsKey._();
  static const themeState = 'theme_state';
  static const onBoardState = 'onboard_state';
  static const dailyWordString = 'daily_word_string';
}
