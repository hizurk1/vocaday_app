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
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  Future<void> _onSearchWordByKeyword(
    SearchWordByKeywordEvent event,
    Emitter<SearchWordState> emit,
  ) async {
    emit(const SearchWordLoadingState());
    if (event.keyword.isNotEmpty) {
      final searchResult = await searchWordsUsecase(event.keyword);
      // await Future.delayed(Durations.long2);

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
