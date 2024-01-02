import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/word/domain/entities/word_entity.dart';
import 'package:vocaday_app/features/word/domain/repositories/word_repository.dart';
import 'package:vocaday_app/features/word/domain/usecases/search_words.dart';

class MockWordRepository extends Mock implements WordRepository {}

void main() {
  late SearchWordsUsecase searchWordsUsecase;
  late MockWordRepository mockWordRepository;

  setUp(() {
    mockWordRepository = MockWordRepository();
    searchWordsUsecase = SearchWordsUsecase(repository: mockWordRepository);
  });

  final tList = [
    const WordEntity(
      word: 'lost',
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
    ),
    const WordEntity(
      word: 'boss',
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

  const testKeyword = 'lost';

  group('Search Word by keyword', () {
    // test('should get list of words contains keyword', () async {
    //   final result = await searchWordsUsecase((testKeyword, tList));

    //   result.fold(
    //     (f) => fail(f.message),
    //     (list) {
    //       expect(
    //         list.$1.isNotEmpty,
    //         true,
    //         reason: "Should has data contains '$testKeyword' keyword",
    //       );
    //     },
    //   );
    // });
    test('should get empty list when keyword does not match any', () async {
      final result = await searchWordsUsecase(('asdf', tList));

      result.fold(
        (f) => fail(f.message),
        (list) {
          expect(list.$1, []);
        },
      );
    });
  });
}
