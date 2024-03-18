import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/managers/shared_preferences.dart';
import '../../../../../word/domain/entities/word_entity.dart';
import '../../../../../word/domain/usecases/get_all_words.dart';
import '../../../domain/usecases/remove_all_favourite_word_usecase.dart';
import '../../../domain/usecases/sync_favourite_word_usecase.dart';

part 'word_favourite_state.dart';

class WordFavouriteCubit extends Cubit<WordFavouriteState> {
  final GetAllWordsUsecase getAllWordsUsecase;
  final SyncFavouriteWordUsecase syncFavouriteWordUsecase;
  final RemoveAllFavouriteWordUsecase removeAllFavouriteWordUsecase;
  final SharedPrefManager sharedPrefManager;

  WordFavouriteCubit(
    this.getAllWordsUsecase,
    this.syncFavouriteWordUsecase,
    this.removeAllFavouriteWordUsecase,
    this.sharedPrefManager,
  ) : super(WordFavouriteEmptyState());

  Future<void> removeAllFavourites(String uid) async {
    emit(WordFavouriteLoadingState());
    sharedPrefManager.clearAllFavouriteWords();

    final result = await removeAllFavouriteWordUsecase(uid);
    result.fold(
      (failure) => emit(WordFavouriteErrorState(failure.message)),
      (_) => emit(const WordFavouriteLoadedState([])),
    );
  }

  Future<bool> syncFavourites(String uid) async {
    emit(WordFavouriteLoadingState());

    final wordEither = await getAllWordsUsecase();

    return await wordEither.fold(
      (failure) {
        emit(WordFavouriteErrorState(failure.message));
        return false;
      },
      (wordList) async {
        final favList = sharedPrefManager.getFavouriteWords;
        final result = await syncFavouriteWordUsecase((uid, favList));

        return await result.fold(
          (failure) {
            emit(WordFavouriteErrorState(failure.message));
            return false;
          },
          (newFavs) async {
            Set<WordEntity> favourites = {};

            //? Merge data from database
            for (String element in newFavs) {
              final word = wordList.firstWhere((e) => e.word == element);
              favourites.add(word);
            }

            //? Save to local
            await sharedPrefManager.saveFavouriteWord(newFavs);

            emit(
              WordFavouriteLoadedState(favourites.toList().reversed.toList()),
            );
            return true;
          },
        );
      },
    );
  }

  Future<void> getAllFavouriteWords() async {
    emit(WordFavouriteLoadingState());

    final wordEither = await getAllWordsUsecase();

    wordEither.fold(
      (failure) => emit(WordFavouriteErrorState(failure.message)),
      (wordList) {
        List<WordEntity> favourites = [];
        final favs = sharedPrefManager.getFavouriteWords;

        for (String element in favs) {
          final word = wordList.firstWhere((e) => e.word == element);
          favourites.add(word);
        }

        emit(WordFavouriteLoadedState(favourites.reversed.toList()));
      },
    );
  }
}
