part of 'leader_board_cubit.dart';

sealed class LeaderBoardState extends Equatable {
  const LeaderBoardState();

  @override
  List<Object> get props => [];
}

final class LeaderBoardEmptyState extends LeaderBoardState {}

final class LeaderBoardLoadingState extends LeaderBoardState {}

final class LeaderBoardLoadedState extends LeaderBoardState {
  final List<UserEntity> points, attendances;

  const LeaderBoardLoadedState({
    required this.points,
    required this.attendances,
  });

  @override
  List<Object> get props => [points, attendances];
}

final class LeaderBoardErrorState extends LeaderBoardState {
  final String message;

  const LeaderBoardErrorState(this.message);
  @override
  List<Object> get props => [message];
}
