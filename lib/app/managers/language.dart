import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../translations/translations.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState.en());
  void changeLanguage(Locale locale) {
    emit(LanguageState(locale));
  }
}

class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  LanguageState.en() : this(AppLocale.en.instance);
  LanguageState.vi() : this(AppLocale.vi.instance);

  @override
  List<Object?> get props => [locale];
}
