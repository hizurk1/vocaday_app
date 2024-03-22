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
        final knowns = sl<SharedPrefManager>().getKnownWords;
        WordEntity? random =
            list.where((e) => !knowns.contains(e.word)).toList().getRandom;
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
          final knowns = sl<SharedPrefManager>().getKnownWords;
          WordEntity? random =
              list.where((e) => !knowns.contains(e.word)).toList().getRandom;
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
    await sl<SharedPrefManager>().saveDailyWord([
      entity.word,
      entity.meanings.first.meaning,
      DateTime.now().ddMMyyyy,
    ]);
  }

  Future<WordEntity?> _getDailyWordLocal(List<WordEntity> list) async {
    final localData = sl<SharedPrefManager>().getDailyWord;

    if (localData.isNotNullOrEmpty) {
      final String word = localData!.first;
      final DateTime date = localData.last.toDate;
      //! If current date == saved date. Returns current saved word.
      //! Otherwise, return null a.k.a generate a new random.
      if (DateTime.now().eqvYearMonthDay(date)) {
        return list.firstWhere((e) => e.word == word);
      }
    }
    return null;
  }
}
