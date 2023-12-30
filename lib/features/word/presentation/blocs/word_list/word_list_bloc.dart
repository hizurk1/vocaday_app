import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/word_entity.dart';
import '../../../domain/usecases/get_all_words.dart';

part 'word_list_event.dart';
part 'word_list_state.dart';

class WordListBloc extends Bloc<WordListEvent, WordListState> {
  final GetAllWordsUsecase getAllWordsUsecase;

  WordListBloc(this.getAllWordsUsecase) : super(const WordListEmptyState()) {
    on<GetAllWordsEvent>(_onGetAllWordsEvent);
  }

  Future<void> _onGetAllWordsEvent(
    GetAllWordsEvent event,
    Emitter<WordListState> emit,
  ) async {
    emit(const WordListLoadingState());

    final result = await getAllWordsUsecase();
    result.fold(
      (failure) => emit(WordListErrorState(failure.message)),
      (list) => emit(WordListLoadedState(list)),
    );
  }
}
