import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/managers/shared_preferences.dart';
import '../../../../injection_container.dart';
import '../../../word/domain/entities/word_entity.dart';
import '../../../word/domain/usecases/get_all_words.dart';

part 'word_favourite_state.dart';

class WordFavouriteCubit extends Cubit<WordFavouriteState> {
  final GetAllWordsUsecase getAllWordsUsecase;

  WordFavouriteCubit(this.getAllWordsUsecase)
      : super(WordFavouriteEmptyState());

  Future<void> getAllFavouriteWords() async {
    emit(WordFavouriteLoadingState());

    final wordEither = await getAllWordsUsecase();

    wordEither.fold(
      (failure) => emit(WordFavouriteErrorState(failure.message)),
      (wordList) {
        List<WordEntity> favourites = [];
        final favs = sl<SharedPrefManager>().getFavouriteWords;

        for (String element in favs) {
          final word = wordList.firstWhere((e) => e.word == element);
          favourites.add(word);
        }

        emit(WordFavouriteLoadedState(favourites.reversed.toList()));
      },
    );
  }
}
