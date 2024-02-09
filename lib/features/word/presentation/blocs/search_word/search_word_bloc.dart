import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/utils/event_transformer.dart';
import '../../../domain/entities/word_entity.dart';
import '../../../domain/usecases/search_words.dart';

part 'search_word_event.dart';
part 'search_word_state.dart';

class SearchWordBloc extends Bloc<SearchWordEvent, SearchWordState> {
  final SearchWordsUsecase searchWordsUsecase;

  SearchWordBloc(this.searchWordsUsecase)
      : super(const SearchWordEmptyState()) {
    on<SearchWordByKeywordEvent>(
      _onSearchWordByKeyword,
      transformer: debounce(const Duration(milliseconds: 250)),
    );
  }

  Future<void> _onSearchWordByKeyword(
    SearchWordByKeywordEvent event,
    Emitter<SearchWordState> emit,
  ) async {
    if (event.keyword.isNotEmpty && event.list.isNotEmpty) {
      emit(const SearchWordLoadingState());

      final searchResult =
          await searchWordsUsecase((event.keyword, event.list));

      searchResult.fold(
        (failure) => emit(SearchWordErrorState(failure.message)),
        (list) => emit(SearchWordLoadedState(
          exactWords: list.$1,
          similarWords: list.$2,
        )),
      );
    } else {
      emit(const SearchWordEmptyState());
    }
  }
}
