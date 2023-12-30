import 'dart:ui';

enum AppLocale { en, vi }

extension AppLocaleExtension on AppLocale {
  Locale get instance {
    switch (this) {
      case AppLocale.en:
        return const Locale('en', 'US');
      case AppLocale.vi:
        return const Locale('vi', 'VN');
      default:
        return const Locale('en', 'US');
    }
  }

  String get languageCode {
    switch (this) {
      case AppLocale.en:
        return 'en';
      case AppLocale.vi:
        return 'vi';
      default:
        return 'en';
    }
  }
}
