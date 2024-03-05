part of 'word_favourite_cubit.dart';

sealed class WordFavouriteState extends Equatable {
  const WordFavouriteState();

  @override
  List<Object> get props => [];
}

final class WordFavouriteEmptyState extends WordFavouriteState {}

final class WordFavouriteLoadingState extends WordFavouriteState {}

final class WordFavouriteLoadedState extends WordFavouriteState {
  final List<WordEntity> words;

  const WordFavouriteLoadedState(this.words);

  @override
  List<Object> get props => [words];
}

final class WordFavouriteErrorState extends WordFavouriteState {
  final String message;

  const WordFavouriteErrorState(this.message);

  @override
  List<Object> get props => [message];
}
