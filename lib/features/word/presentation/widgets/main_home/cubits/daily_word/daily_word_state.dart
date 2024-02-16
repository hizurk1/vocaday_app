part of 'daily_word_cubit.dart';

sealed class DailyWordState extends Equatable {
  const DailyWordState();

  @override
  List<Object> get props => [];
}

final class DailyWordEmptyState extends DailyWordState {}

final class DailyWordLoadingState extends DailyWordState {}

final class DailyWordLoadedState extends DailyWordState {
  final WordEntity entity;

  const DailyWordLoadedState(this.entity);

  @override
  List<Object> get props => [entity];
}

final class DailyWordErrorState extends DailyWordState {
  final String message;

  const DailyWordErrorState(this.message);

  @override
  List<Object> get props => [message];
}
