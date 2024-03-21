class AppValueConst {
  AppValueConst._();

  /// In byte (~5MB).
  ///
  /// Convert to MB: maxImgUploadSize / 1024 / 1024
  static const maxImgUploadSize = 5242880;
  static const maxItemLoad = 50;
  static const minWordInBagToPlay = 5;
  static const timeForQuiz = 30; // seconds
  static const attendancePoint = 1;
  static const attendanceGold = 1;
}

class AppStringConst {
  AppStringConst._();
  // String
  static const packageName = "com.vocaday.vocaday_app";
  static const notificationMethodChannel =
      "com.vocaday.vocaday_app/notification_service";
  static const alphabet = "abcdefghijklmnopqrstuvwxyz";
  static const privacyPolicyUrl =
      "https://sites.google.com/view/vocaday-privacypolicy";
  static const aboutUsUrl = "https://github.com/helkaloic/vocaday_app";
  static const email = "email";

  // Mini Game
  static const quiz = "Quiz";
  static const slidingPuzzle = "Sliding Puzzle";
  static const slidingPuzzleEmpty = "#";

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
  static const knownWordStringL = 'known_word_string_l';
  static const cartBagWordStringL = 'cart_bag_word_string_l';
  static const slidingPuzzleMusic = 'sliding_puzzle_music';
  static const slidingPuzzleSound = 'sliding_puzzle_sound';
  static const coachMarkMain = 'coach_mark_main';
  static const coachMarkHome = 'coach_mark_home';
  static const coachMarkWordDetail = 'coach_mark_word_detail';
}
