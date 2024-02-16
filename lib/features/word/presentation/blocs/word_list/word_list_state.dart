part of 'word_list_cubit.dart';

sealed class WordListState extends Equatable {
  const WordListState();

  @override
  List<Object> get props => [];
}

final class WordListEmptyState extends WordListState {
  const WordListEmptyState();
}

final class WordListLoadingState extends WordListState {
  const WordListLoadingState();
}

final class WordListLoadedState extends WordListState {
  final List<WordEntity> wordList;

  const WordListLoadedState(this.wordList);

  @override
  List<Object> get props => [wordList];
}

final class WordListErrorState extends WordListState {
  final String message;

  const WordListErrorState(this.message);
  @override
  List<Object> get props => [message];
}
