// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sliding_puzzle_cubit.dart';

enum SlidingPuzzleStatus { init, loading, loaded, done, error }

class SlidingPuzzleState extends Equatable {
  const SlidingPuzzleState({
    required this.status,
    this.index = 0,
    this.gridSize = 1,
    this.count = 0,
    this.list = const [],
    this.isCompleted = false,
    this.message,
    this.playSound = false,
    this.playMusic = false,
  });

  final SlidingPuzzleStatus status;
  final int index;
  final int gridSize;
  final int count;
  final List<String> list;
  final bool isCompleted;
  final String? message;
  final bool playSound;
  final bool playMusic;

  @override
  List<Object?> get props => [
        status,
        index,
        gridSize,
        count,
        list,
        isCompleted,
        message,
        playSound,
        playMusic
      ];

  SlidingPuzzleState copyWith({
    SlidingPuzzleStatus? status,
    int? index,
    int? gridSize,
    int? count,
    List<String>? list,
    bool? isCompleted,
    String? message,
    bool? playSound,
    bool? playMusic,
  }) {
    return SlidingPuzzleState(
      status: status ?? this.status,
      index: index ?? this.index,
      gridSize: gridSize ?? this.gridSize,
      count: count ?? this.count,
      list: list ?? this.list,
      isCompleted: isCompleted ?? this.isCompleted,
      message: message ?? this.message,
      playSound: playSound ?? this.playSound,
      playMusic: playMusic ?? this.playMusic,
    );
  }
}
