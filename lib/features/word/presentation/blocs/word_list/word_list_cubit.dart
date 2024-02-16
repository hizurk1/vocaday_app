import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/word_entity.dart';
import '../../../domain/usecases/get_all_words.dart';

part 'word_list_state.dart';

class WordListCubit extends Cubit<WordListState> {
  final GetAllWordsUsecase getAllWordsUsecase;

  WordListCubit(this.getAllWordsUsecase) : super(const WordListEmptyState());

  Future<void> getAllWords() async {
    emit(const WordListLoadingState());

    final result = await getAllWordsUsecase();
    result.fold(
      (failure) => emit(WordListErrorState(failure.message)),
      (list) => emit(WordListLoadedState(list)),
    );
  }
}
