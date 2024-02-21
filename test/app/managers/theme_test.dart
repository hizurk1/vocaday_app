import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocaday_app/app/constants/app_const.dart';
import 'package:vocaday_app/app/managers/shared_preferences.dart';
import 'package:vocaday_app/app/managers/theme.dart';

void main() async {
  late SharedPrefManager prefs;
  // late ThemeCubit themeBloc;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({AppPrefsKey.themeState: true});
    final ref = await SharedPreferences.getInstance();
    prefs = SharedPrefManager(ref);
    // themeBloc = ThemeCubit(prefs);
  });

  group('Theme Service', () {
    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeState] when toggleTheme is called.',
      build: () => ThemeCubit(prefs),
      act: (bloc) async => await bloc.toggleTheme(ThemeMode.system),
      wait: const Duration(seconds: 2),
      expect: () => [
        const ThemeState(ThemeMode.system),
      ],
    );
  });
}
