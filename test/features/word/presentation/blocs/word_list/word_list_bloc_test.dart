import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/core/errors/failure.dart';
import 'package:vocaday_app/features/word/domain/entities/word_entity.dart';
import 'package:vocaday_app/features/word/domain/usecases/get_all_words.dart';
import 'package:vocaday_app/features/word/presentation/blocs/word_list/word_list_bloc.dart';

class MockGetAllWordsUsecase extends Mock implements GetAllWordsUsecase {}

void main() {
  final mockGetAllWordsUsecase = MockGetAllWordsUsecase();
  final wordListBloc = WordListBloc(mockGetAllWordsUsecase);

  final testEntities = [
    const WordEntity(
      word: 'word',
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

  group('Word List Bloc', () {
    test('should get [WordListEmptyState] as a default', () {
      expect(wordListBloc.state, const WordListEmptyState());
    });

    blocTest<WordListBloc, WordListState>(
      'emits [WordListLoadingState] & [WordListLoadedState] when GetAllWordsEvent is added.',
      build: () {
        when(() => mockGetAllWordsUsecase())
            .thenAnswer((_) async => Right(testEntities));
        return WordListBloc(mockGetAllWordsUsecase);
      },
      act: (bloc) => bloc.add(GetAllWordsEvent()),
      expect: () => <WordListState>[
        const WordListLoadingState(),
        WordListLoadedState(testEntities),
      ],
    );
    blocTest<WordListBloc, WordListState>(
      'emits [WordListLoadingState] & [WordListErrorState] when GetAllWordsEvent is added.',
      build: () {
        when(() => mockGetAllWordsUsecase())
            .thenAnswer((_) async => const Left(UnknownFailure('')));
        return WordListBloc(mockGetAllWordsUsecase);
      },
      act: (bloc) => bloc.add(GetAllWordsEvent()),
      expect: () => <WordListState>[
        const WordListLoadingState(),
        const WordListErrorState(''),
      ],
    );
  });
}
