import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/word/domain/repositories/word_repository.dart';

class MockWordRepository extends Mock implements WordRepository {}

void main() {
  // late SearchWordsUsecase searchWordsUsecase;
  // late MockWordRepository mockWordRepository;

  // setUp(() {
  //   mockWordRepository = MockWordRepository();
  //   searchWordsUsecase = SearchWordsUsecase(repository: mockWordRepository);
  // });

  // final testEntities = [
  //   const WordEntity(
  //     word: 'word',
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

  // const testKeyword = 'word';

  // group('Search Word by keyword', () {
  //   test('should get list of words contains keyword', () async {
  //     when(() => mockWordRepository.getAllWords())
  //         .thenAnswer((_) async => Right(testEntities));

  //     final result = await searchWordsUsecase(testKeyword);

  //     result.fold(
  //       (f) => fail(f.message),
  //       (list) {
  //         expect(
  //           list.$1.isNotEmpty,
  //           true,
  //           reason: "Should has data contains '$testKeyword' keyword",
  //         );
  //       },
  //     );
  //   });
  //   test('should get empty list when keyword does not match any', () async {
  //     final result = await searchWordsUsecase('asdf');

  //     result.fold(
  //       (f) => fail(f.message),
  //       (list) {
  //         expect(list.$1, []);
  //       },
  //     );
  //   });
  // });
}
