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
  // String
  static const packageName = "com.vocaday.vocaday_app";
  static const notificationMethodChannel =
      "com.vocaday.vocaday_app/notification_service";
  static const alphabet = "abcdefghijklmnopqrstuvwxyz";

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
  static const scheduleNotiDateString = 'schedule_noti_date_string';
  static const favouriteWordStringL = 'favourite_word_string_l';
  static const cartBagWordStringL = 'cart_bag_word_string_l';
}
