// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'game_quiz_cubit.dart';

enum GameQuizStatus { initial, loading, success, error }

class GameQuizState extends Equatable {
  final GameQuizStatus status;
  final String? message;

  const GameQuizState({required this.status, this.message});

  @override
  List<Object?> get props => [status, message];

  GameQuizState copyWith({
    GameQuizStatus? status,
    String? message,
  }) {
    return GameQuizState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
