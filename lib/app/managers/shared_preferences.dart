import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/extensions/date_time.dart';
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
  /// '[word, definition, dd/MM/yyyy]'
  Future<void> saveDailyWord(List<String> wordData) async {
    await prefs.setStringList(AppPrefsKey.dailyWordString, wordData);
  }

  /// '[word, definition, dd/MM/yyyy]'
  List<String>? get getDailyWord =>
      prefs.getStringList(AppPrefsKey.dailyWordString);

  //! Notification [SettingPage]
  Future<void> saveScheduleNotiTime(TimeOfDay time) async {
    await prefs.setString(AppPrefsKey.scheduleNotiDateString, time.getHHmm);
  }

  TimeOfDay? get getScheduleNotiTime =>
      prefs.getString(AppPrefsKey.scheduleNotiDateString)?.toTimeOfDay;

  void removeScheduleNotiTime() =>
      prefs.remove(AppPrefsKey.scheduleNotiDateString);

  //! Favourite word
  List<String> get getFavouriteWords =>
      prefs.getStringList(AppPrefsKey.favouriteWordStringL) ?? [];

  Future<void> addFavouriteWord(String word) async {
    Set<String> list =
        prefs.getStringList(AppPrefsKey.favouriteWordStringL)?.toSet() ?? {};
    list.add(word);
    await prefs.setStringList(AppPrefsKey.favouriteWordStringL, list.toList());
  }

  Future<void> saveFavouriteWord(List<String> words) async {
    await prefs.setStringList(AppPrefsKey.favouriteWordStringL, words);
  }

  Future<void> removeFavouriteWord(String word) async {
    Set<String> list =
        prefs.getStringList(AppPrefsKey.favouriteWordStringL)?.toSet() ?? {};
    if (list.isNotEmpty) {
      list.removeWhere((element) => element == word);
      await prefs.setStringList(
          AppPrefsKey.favouriteWordStringL, list.toList());
    }
  }

  void clearAllFavouriteWords() =>
      prefs.remove(AppPrefsKey.favouriteWordStringL);

  //! Favourite word
  List<String> get getKnownWords =>
      prefs.getStringList(AppPrefsKey.knownWordStringL) ?? [];

  Future<void> addKnownWord(String word) async {
    Set<String> list =
        prefs.getStringList(AppPrefsKey.knownWordStringL)?.toSet() ?? {};
    list.add(word);
    await prefs.setStringList(AppPrefsKey.knownWordStringL, list.toList());
  }

  Future<void> saveKnownWord(List<String> words) async {
    await prefs.setStringList(AppPrefsKey.knownWordStringL, words);
  }

  Future<void> removeKnownWord(String word) async {
    Set<String> list =
        prefs.getStringList(AppPrefsKey.knownWordStringL)?.toSet() ?? {};
    if (list.isNotEmpty) {
      list.removeWhere((element) => element == word);
      await prefs.setStringList(AppPrefsKey.knownWordStringL, list.toList());
    }
  }

  void clearAllKnownWords() => prefs.remove(AppPrefsKey.knownWordStringL);

  //! Cart
  Future<void> setCartBags(List<String> list) async {
    await prefs.setStringList(AppPrefsKey.cartBagWordStringL, list);
  }

  List<String> get getCartBags =>
      prefs.getStringList(AppPrefsKey.cartBagWordStringL) ?? [];

  void removeLocalCartBags() => prefs.remove(AppPrefsKey.cartBagWordStringL);
}
