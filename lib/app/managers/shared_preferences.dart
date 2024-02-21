import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/extensions/string.dart';
import '../constants/app_const.dart';

class SharedPrefManager {
  SharedPrefManager(this.prefs);

  final SharedPreferences prefs;

  //! Theme
  Future<void> saveTheme(String mode) async {
    await prefs.setString(AppPrefsKey.themeState, mode);
  }

  /// by default: system
  ThemeMode getTheme() {
    final mode = prefs.getString(AppPrefsKey.themeState);
    if (mode.isNotNullOrEmpty) {
      if (mode == ThemeMode.light.name) return ThemeMode.light;
      if (mode == ThemeMode.dark.name) return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  //! First Choosen Language
  Future<void> saveOnboardCheckedIn() async {
    await prefs.setBool(AppPrefsKey.onBoardState, true);
  }

  bool get isCheckedInOnboard =>
      prefs.getBool(AppPrefsKey.onBoardState) ?? false;

  //! Daily word [HomePage]
  /// 'word+dd/MM/yyyy'
  Future<void> saveDailyWord(String wordData) async {
    await prefs.setString(AppPrefsKey.dailyWordString, wordData);
  }

  /// 'word+dd/MM/yyyy'
  String? get getDailyWord => prefs.getString(AppPrefsKey.dailyWordString);
}
