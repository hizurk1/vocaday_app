import 'dart:math';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../domain/usecases/update_user_gold.dart';
import '../../../domain/usecases/update_user_point.dart';

part 'sliding_puzzle_state.dart';

class SlidingPuzzleCubit extends Cubit<SlidingPuzzleState> {
  final String? uid;
  final List<WordEntity> words;
  final UpdateUserPointUsecase updateUserPointUsecase;
  final UpdateUserGoldUsecase updateUserGoldUsecase;

  SlidingPuzzleCubit({
    this.uid,
    required this.words,
    required this.updateUserPointUsecase,
    required this.updateUserGoldUsecase,
  }) : super(const SlidingPuzzleState(status: SlidingPuzzleStatus.init));

  // Generate (e.g 3x3 hello): ['#', 'e', 'e', 'h', 'l', 'a', 'a', 'o', 'c']
  Future<void> generateList() async {
    emit(state.copyWith(
      status: SlidingPuzzleStatus.loading,
      isCompleted: false,
    ));
    await Future.delayed(Durations.extralong4);

    final word = words[state.index].word;
    final gridSize = max(3, sqrt(word.length + 1).ceil()); //! Avoid size < 3
    List<String> result = word.split('');
    while (result.length < gridSize * gridSize - 1) {
      result.add(String.fromCharCode(Random().nextInt(26) + 97).toUpperCase());
    }

    emit(state.copyWith(
      status: SlidingPuzzleStatus.loaded,
      gridSize: gridSize,
      list: result
        ..shuffle()
        ..insert(0, AppStringConst.slidingPuzzleEmpty),
    ));
  }

  void gridItemClick(int index) {
    if (!state.isCompleted) {
      const empty = AppStringConst.slidingPuzzleEmpty;
      final size = state.gridSize;
      List<String> list = List<String>.from(state.list);
      if ((index - 1 >= 0 && list[index - 1] == empty && index % size != 0) ||
          (index + 1 < size * size &&
              list[index + 1] == empty &&
              (index + 1) % size != 0) ||
          (index - size >= 0 && list[index - size] == empty) ||
          (index + size < size * size && list[index + size] == empty)) {
        list.swap(list.indexOf(empty), index);
        emit(state.copyWith(list: list));
        checkResult();
      }
    }
  }

  void checkResult() {
    final word = words[state.index].word;
    final result = state.list.sublist(0, word.length).join();
    if (word == result) {
      emit(state.copyWith(isCompleted: true, count: state.count + 1));
    }
  }

  void onNextWord() {
    if (state.index + 1 < words.length) {
      emit(state.copyWith(index: state.index + 1));
      generateList();
    } else {
      calculateResult();
    }
  }

  Future<void> calculateResult() async {
    if (uid != null) {
      emit(state.copyWith(status: SlidingPuzzleStatus.loading));
      final point = state.count * 2;
      final gold = 1 + state.count ~/ AppValueConst.minWordInBagToPlay;

      final pointRes = await updateUserPointUsecase((uid!, point));
      await pointRes.fold(
        (failure) async => state.copyWith(
          status: SlidingPuzzleStatus.error,
          message: failure.message,
        ),
        (_) async {
          if (state.count > 0) {
            final goldRes = await updateUserGoldUsecase((uid!, gold));
            goldRes.fold(
              (failure) => state.copyWith(
                status: SlidingPuzzleStatus.error,
                message: failure.message,
              ),
              (_) => emit(state.copyWith(status: SlidingPuzzleStatus.done)),
            );
          } else {
            emit(state.copyWith(status: SlidingPuzzleStatus.done));
          }
        },
      );
    } else {
      state.copyWith(
        status: SlidingPuzzleStatus.error,
        message: AppStringConst.unexpectedErrorMessage,
      );
    }
  }
}
