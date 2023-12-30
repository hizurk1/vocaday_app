part of 'search_word_bloc.dart';

sealed class SearchWordState extends Equatable {
  const SearchWordState();

  @override
  List<Object> get props => [];
}

final class SearchWordEmptyState extends SearchWordState {
  const SearchWordEmptyState();
}

final class SearchWordLoadingState extends SearchWordState {
  const SearchWordLoadingState();
}

final class SearchWordLoadedState extends SearchWordState {
  final List<WordEntity> exactWords;
  final List<WordEntity> similarWords;

  const SearchWordLoadedState({
    required this.exactWords,
    required this.similarWords,
  });

  @override
  List<Object> get props => [exactWords, similarWords];
}

final class SearchWordErrorState extends SearchWordState {
  final String message;

  const SearchWordErrorState(this.message);
  @override
  List<Object> get props => [message];
}
