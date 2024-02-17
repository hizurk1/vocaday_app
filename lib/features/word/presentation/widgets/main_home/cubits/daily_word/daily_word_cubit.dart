import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../../../app/managers/shared_preferences.dart';
import '../../../../../../../app/translations/translations.dart';
import '../../../../../../../core/extensions/date_time.dart';
import '../../../../../../../core/extensions/list.dart';
import '../../../../../../../core/extensions/string.dart';
import '../../../../../../../injection_container.dart';
import '../../../../../domain/entities/word_entity.dart';
import '../../../../../domain/usecases/get_all_words.dart';

part 'daily_word_state.dart';

class DailyWordCubit extends Cubit<DailyWordState> {
  DailyWordCubit() : super(DailyWordEmptyState());

  Future<void> reload() async {
    emit(DailyWordLoadingState());

    final result = await sl<GetAllWordsUsecase>().call();
    await Future.delayed(Durations.medium2);

    result.fold(
      (failure) => emit(DailyWordErrorState(failure.message)),
      (list) async {
        WordEntity? random = list.getRandom;
        if (random != null) {
          await _setDailyWordLocal(random);
          emit(DailyWordLoadedState(random));
        } else {
          emit(DailyWordErrorState(LocaleKeys.search_not_found.tr()));
        }
      },
    );
  }

  Future<void> getDailyWord(List<WordEntity> words) async {
    emit(DailyWordLoadingState());

    final result = await sl<GetAllWordsUsecase>().call();

    result.fold(
      (failure) => emit(DailyWordErrorState(failure.message)),
      (list) async {
        final WordEntity? entity = await _getDailyWordLocal(list);

        if (entity != null) {
          emit(DailyWordLoadedState(entity));
        } else {
          WordEntity? random = list.getRandom;
          if (random != null) {
            await _setDailyWordLocal(random);
            emit(DailyWordLoadedState(random));
          } else {
            emit(DailyWordErrorState(LocaleKeys.search_not_found.tr()));
          }
        }
      },
    );
  }

  Future<void> _setDailyWordLocal(WordEntity entity) async {
    final data = "${entity.word}+${DateTime.now().ddMMyyyy}";
    await sl<SharedPrefManager>().saveDailyWord(data);
  }

  Future<WordEntity?> _getDailyWordLocal(List<WordEntity> list) async {
    final localData = sl<SharedPrefManager>().getDailyWord;

    if (localData.isNotNullOrEmpty) {
      final [word, date] = localData!.split('+');
      //! If current date == saved date. Returns current saved word.
      //! Otherwise, return null a.k.a generate a new random.
      if (DateTime.now().eqvYearMonthDay(date.toDate)) {
        return list.firstWhere((e) => e.word == word);
      }
    }
    return null;
  }
}
