import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../word/domain/entities/word_entity.dart';
import '../../../../../word/domain/usecases/get_all_words.dart';
import '../../../domain/usecases/add_known_words.dart';
import '../../../domain/usecases/remove_all_known_word.dart';
import '../../../domain/usecases/sync_known_word.dart';

part 'known_word_state.dart';

class KnownWordCubit extends Cubit<KnownWordState> {
  final GetAllWordsUsecase getAllWordsUsecase;
  final RemoveAllKnownWordUsecase removeAllKnownWordUsecase;
  final SyncKnownWordUsecase syncKnownWordUsecase;
  final AddKnownWordsUsecase addKnownWordsUsecase;
  final SharedPrefManager sharedPrefManager;
  KnownWordCubit(
    this.getAllWordsUsecase,
    this.removeAllKnownWordUsecase,
    this.syncKnownWordUsecase,
    this.addKnownWordsUsecase,
    this.sharedPrefManager,
  ) : super(const KnownWordEmptyState());

  List<WordEntity> _filterWordEntityList(List<WordEntity> wordList) {
    List<WordEntity> knowns = [];
    final local = sharedPrefManager.getKnownWords;

    for (String element in local) {
      final word = wordList.firstWhere((e) => e.word == element);
      knowns.add(word);
    }
    return knowns;
  }

  Future<void> addKnownWordList(String uid, List<String> knowns) async {
    emit(const KnownWordLoadingState());
    try {
      final wordEither = await getAllWordsUsecase();

      await wordEither.fold(
        (failure) async => emit(KnownWordErrorState(failure.message)),
        (wordList) async {
          final result = await addKnownWordsUsecase((uid, knowns));
          result.fold(
            (failure) => emit(KnownWordErrorState(failure.message)),
            (_) {
              emit(KnownWordLoadedState(
                _filterWordEntityList(wordList).reversed.toList(),
              ));
            },
          );
        },
      );
    } on UnimplementedError catch (e) {
      emit(KnownWordErrorState(e.message ?? ''));
    }
  }

  Future<void> addKnownWord(String word, List<WordEntity> wordList) async {
    emit(const KnownWordLoadingState());
    try {
      await sharedPrefManager.addKnownWord(word);

      emit(KnownWordLoadedState(
        _filterWordEntityList(wordList).reversed.toList(),
      ));
    } on UnimplementedError catch (e) {
      emit(KnownWordErrorState(e.message ?? ''));
    }
  }

  Future<bool> syncKnowns(String uid) async {
    emit(const KnownWordLoadingState());

    final wordEither = await getAllWordsUsecase();

    return await wordEither.fold(
      (failure) async {
        emit(KnownWordErrorState(failure.message));
        return false;
      },
      (wordList) async {
        final knownList = sharedPrefManager.getKnownWords;
        final result = await syncKnownWordUsecase((uid, knownList));

        return await result.fold(
          (failure) {
            emit(KnownWordErrorState(failure.message));
            return false;
          },
          (newKnowns) async {
            Set<WordEntity> knowns = {};

            //? Merge data from database
            for (String element in newKnowns) {
              final word = wordList.firstWhere((e) => e.word == element);
              knowns.add(word);
            }

            //? Save to local
            await sharedPrefManager.saveKnownWord(newKnowns);

            emit(
              KnownWordLoadedState(knowns.toList().reversed.toList()),
            );
            return true;
          },
        );
      },
    );
  }

  Future<void> removeAllKnowns(String uid) async {
    emit(const KnownWordLoadingState());
    sharedPrefManager.clearAllFavouriteWords();

    final result = await removeAllKnownWordUsecase(uid);
    result.fold(
      (failure) => emit(KnownWordErrorState(failure.message)),
      (_) => emit(const KnownWordLoadedState([])),
    );
  }

  Future<void> getAllKnownWords() async {
    emit(const KnownWordLoadingState());

    final wordEither = await getAllWordsUsecase();

    wordEither.fold(
      (failure) => emit(KnownWordErrorState(failure.message)),
      (wordList) {
        List<WordEntity> knowns = [];
        final local = sharedPrefManager.getKnownWords;

        for (String element in local) {
          final word = wordList.firstWhere((e) => e.word == element);
          knowns.add(word);
        }

        emit(KnownWordLoadedState(knowns.reversed.toList()));
      },
    );
  }
}
