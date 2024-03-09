part of 'known_word_cubit.dart';

sealed class KnownWordState extends Equatable {
  const KnownWordState();

  @override
  List<Object> get props => [];
}

final class KnownWordEmptyState extends KnownWordState {
  const KnownWordEmptyState();
}

final class KnownWordLoadingState extends KnownWordState {
  const KnownWordLoadingState();
}

final class KnownWordLoadedState extends KnownWordState {
  final List<WordEntity> words;

  const KnownWordLoadedState(this.words);

  @override
  List<Object> get props => [words];
}

final class KnownWordErrorState extends KnownWordState {
  final String message;

  const KnownWordErrorState(this.message);
  @override
  List<Object> get props => [message];
}
