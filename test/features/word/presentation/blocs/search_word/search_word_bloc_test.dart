import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/word/domain/entities/word_entity.dart';
import 'package:vocaday_app/features/word/domain/usecases/search_words.dart';
import 'package:vocaday_app/features/word/presentation/blocs/search_word/search_word_bloc.dart';

class MockSearchWordsUsecase extends Mock implements SearchWordsUsecase {}

void main() {
  final mockSearchWordsUsecase = MockSearchWordsUsecase();
  final searchWordBloc = SearchWordBloc(mockSearchWordsUsecase);

  // final tList = [
  //   const WordEntity(
  //     word: 'lost',
  //     meanings: [
  //       MeaningEntity(
  //         type: 'type',
  //         meaning: 'meaning',
  //         synonyms: ['synonyms'],
  //         examples: ['examples'],
  //       )
  //     ],
  //     synonyms: ['synonyms'],
  //     antonyms: ['antonyms'],
  //   ),
  //   const WordEntity(
  //     word: 'most',
  //     meanings: [
  //       MeaningEntity(
  //         type: 'type',
  //         meaning: 'meaning',
  //         synonyms: ['synonyms'],
  //         examples: ['examples'],
  //       )
  //     ],
  //     synonyms: ['synonyms'],
  //     antonyms: ['antonyms'],
  //   )
  // ];

  final testEntities = [
    const WordEntity(
      word: 'testword',
      meanings: [
        MeaningEntity(
          type: 'type',
          meaning: 'meaning',
          synonyms: ['synonyms'],
          examples: ['examples'],
        )
      ],
      synonyms: ['synonyms'],
      antonyms: ['antonyms'],
    )
  ];

  const testKeyword = 'test';

  group('Search Word Bloc', () {
    test('should get [SearchWordEmptyState] as a default', () {
      expect(searchWordBloc.state, const SearchWordEmptyState());
    });

    blocTest<SearchWordBloc, SearchWordState>(
      'emits [SearchWordEmptyState] when SearchWordByKeywordEvent is added.',
      build: () {
        when(() => mockSearchWordsUsecase(testKeyword))
            .thenAnswer((_) async => const Right(([], [])));
        return SearchWordBloc(mockSearchWordsUsecase);
      },
      act: (bloc) => bloc.add(const SearchWordByKeywordEvent(keyword: '')),
      expect: () => <SearchWordState>[
        const SearchWordLoadingState(),
        const SearchWordEmptyState(),
      ],
    );
    blocTest<SearchWordBloc, SearchWordState>(
      'emits [SearchWordLoadingState] & [SearchWordLoadedState] when SearchWordByKeywordEvent is added.',
      build: () {
        when(() => mockSearchWordsUsecase(testKeyword))
            .thenAnswer((_) async => Right((testEntities, [])));
        return SearchWordBloc(mockSearchWordsUsecase);
      },
      wait: const Duration(milliseconds: 800),
      act: (bloc) => bloc.add(const SearchWordByKeywordEvent(
        keyword: testKeyword,
      )),
      expect: () => <SearchWordState>[
        const SearchWordLoadingState(),
        SearchWordLoadedState(exactWords: testEntities, similarWords: const []),
      ],
    );
    blocTest<SearchWordBloc, SearchWordState>(
      'emits [SearchWordLoadingState] & [SearchWordErrorState] when SearchWordByKeywordEvent is added.',
      build: () {
        when(() => mockSearchWordsUsecase(testKeyword))
            .thenAnswer((_) async => const Left(UnknownFailure('')));
        return SearchWordBloc(mockSearchWordsUsecase);
      },
      wait: const Duration(milliseconds: 800),
      act: (bloc) => bloc.add(const SearchWordByKeywordEvent(
        keyword: testKeyword,
      )),
      expect: () => <SearchWordState>[
        const SearchWordLoadingState(),
        const SearchWordErrorState(''),
      ],
    );
  });
}
