import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_string.dart';

class SharedPrefManager {
  SharedPrefManager(this.prefs);

  final SharedPreferences prefs;

  //! Theme
  Future<void> saveTheme(int theme) async {
    await prefs.setInt(
      AppPrefsKey.themeState,
      theme, //? 0: light - 1: dark - 2: system
    );
  }

  int getTheme() => prefs.getInt(AppPrefsKey.themeState) ?? 0;

  //! First Choosen Language
  Future<void> saveOnboardCheckedIn() async {
    await prefs.setBool(AppPrefsKey.onBoardState, true);
  }

  bool get isCheckedInOnboard =>
      prefs.getBool(AppPrefsKey.onBoardState) ?? false;
}
