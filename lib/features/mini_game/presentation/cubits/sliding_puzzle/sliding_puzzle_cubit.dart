import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/constants/app_const.dart';
import '../../../../../app/constants/gen/assets.gen.dart';
import '../../../../../app/managers/shared_preferences.dart';
import '../../../../word/domain/entities/word_entity.dart';
import '../../../domain/usecases/update_user_gold.dart';
import '../../../domain/usecases/update_user_point.dart';

part 'sliding_puzzle_state.dart';

class SlidingPuzzleCubit extends Cubit<SlidingPuzzleState> {
  final String? uid;
  final List<WordEntity> words;
  final UpdateUserPointUsecase updateUserPointUsecase;
  final UpdateUserGoldUsecase updateUserGoldUsecase;
  final SharedPrefManager sharedPrefManager;

  late final AudioPlayer _soundPlayer;
  late final AudioPlayer _musicPlayer;
  late final AudioPlayer _congratsPlayer;

  SlidingPuzzleCubit({
    this.uid,
    required this.words,
    required this.updateUserPointUsecase,
    required this.updateUserGoldUsecase,
    required this.sharedPrefManager,
  }) : super(const SlidingPuzzleState(status: SlidingPuzzleStatus.init)) {
    _initAudio();
  }

  Future _initAudio() async {
    AudioCache.instance = AudioCache(prefix: '');
    _musicPlayer = AudioPlayer();
    _soundPlayer = AudioPlayer();
    _congratsPlayer = AudioPlayer();
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    // await _soundPlayer.setPlayerMode(PlayerMode.lowLatency);

    if (sharedPrefManager.getSlidingPuzzleMusic) {
      await _musicPlayer.play(AssetSource(Assets.sounds.musicBackground));
      emit(state.copyWith(playMusic: true));
    }
    if (sharedPrefManager.getSlidingPuzzleSound) {
      emit(state.copyWith(playSound: true));
    }
  }

  @override
  Future<void> close() async {
    _musicPlayer.dispose();
    _soundPlayer.dispose();
    _congratsPlayer.dispose();
    return super.close();
  }

  Future onPlayMusic(bool value) async {
    if (value) {
      await _musicPlayer.play(AssetSource(Assets.sounds.musicBackground));
    } else {
      await _musicPlayer.stop();
    }
    emit(state.copyWith(playMusic: value));
    await sharedPrefManager.slidingPuzzleMusic(value);
  }

  Future onPlaySound(bool value) async {
    emit(state.copyWith(playSound: value));
    await sharedPrefManager.slidingPuzzleSound(value);
  }

  Future _playSound() async {
    if (state.playSound) {
      if (_soundPlayer.state == PlayerState.playing) {
        await _soundPlayer.stop();
      }
      await _soundPlayer.play(
        AssetSource(Assets.sounds.buttonClick),
        volume: 0.4,
      );
    }
  }

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
    _playSound();
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
          if (state.playSound) {
            await _congratsPlayer.play(
              AssetSource(Assets.sounds.congrats),
              volume: 0.4,
            );
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
