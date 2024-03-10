import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/update_user_gold.dart';
import '../../../domain/usecases/update_user_point.dart';

part 'game_quiz_state.dart';

class GameQuizCubit extends Cubit<GameQuizState> {
  final UpdateUserPointUsecase updateUserPointUsecase;
  final UpdateUserGoldUsecase updateUserGoldUsecase;

  GameQuizCubit(
    this.updateUserPointUsecase,
    this.updateUserGoldUsecase,
  ) : super(const GameQuizState(status: GameQuizStatus.initial));

  Future<void> calculateResult({
    required String uid,
    required int point,
    required int gold,
  }) async {
    emit(state.copyWith(status: GameQuizStatus.loading));

    final resultPoint = await updateUserPointUsecase((uid, point));
    await resultPoint.fold(
      (failure) async => emit(state.copyWith(
        status: GameQuizStatus.error,
        message: failure.message,
      )),
      (_) async {
        if (gold > 0) {
          final resultGold = await updateUserGoldUsecase((uid, gold));
          resultGold.fold(
            (failure) => emit(state.copyWith(
              status: GameQuizStatus.error,
              message: failure.message,
            )),
            (_) => emit(state.copyWith(status: GameQuizStatus.success)),
          );
        } else {
          emit(state.copyWith(status: GameQuizStatus.success));
        }
      },
    );
  }
}
