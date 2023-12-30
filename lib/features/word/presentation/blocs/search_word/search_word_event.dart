part of 'search_word_bloc.dart';

sealed class SearchWordEvent extends Equatable {
  const SearchWordEvent();

  @override
  List<Object> get props => [];
}

final class SearchWordByKeywordEvent extends SearchWordEvent {
  final String keyword;
  final List<WordEntity> list;

  const SearchWordByKeywordEvent({
    required this.keyword,
    required this.list,
  });

  @override
  List<Object> get props => [keyword, list];
}
