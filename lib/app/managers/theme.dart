import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'shared_preferences.dart';

//* Cubit
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPrefManager prefService;
  ThemeCubit(this.prefService) : super(const ThemeState.system());

  void fetchTheme() {
    final theme = prefService.getTheme();
    emit(
      theme == ThemeMode.light
          ? const ThemeState.light()
          : theme == ThemeMode.dark
              ? const ThemeState.dark()
              : const ThemeState.system(),
    );
  }

  Future<void> toggleTheme(ThemeMode mode) async {
    final themeState = mode == ThemeMode.light
        ? const ThemeState.light()
        : mode == ThemeMode.dark
            ? const ThemeState.dark()
            : const ThemeState.system();
    await prefService.saveTheme(mode.name);
    emit(themeState);
  }
}

//* State
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  const ThemeState.light() : this(ThemeMode.light);

  const ThemeState.dark() : this(ThemeMode.dark);

  const ThemeState.system() : this(ThemeMode.system);

  @override
  List<Object> get props => [themeMode];
}
