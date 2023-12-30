part of 'word_list_bloc.dart';

sealed class WordListEvent extends Equatable {
  const WordListEvent();

  @override
  List<Object> get props => [];
}

final class GetAllWordsEvent extends WordListEvent {}
