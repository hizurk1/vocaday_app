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
}
