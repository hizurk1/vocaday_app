import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/word/domain/entities/word_entity.dart';
import 'package:vocaday_app/features/word/domain/repositories/word_repository.dart';
import 'package:vocaday_app/features/word/domain/usecases/get_all_words.dart';

class MockWordRepository extends Mock implements WordRepository {}

void main() {
  late GetAllWordsUsecase getAllWords;
  late MockWordRepository mockWordRepository;

  setUp(() {
    mockWordRepository = MockWordRepository();
    getAllWords = GetAllWordsUsecase(repository: mockWordRepository);
  });

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

  test('should get word entity from repository', () async {
    when(() => mockWordRepository.getAllWords())
        .thenAnswer((_) async => Right(testEntities));

    final result = await getAllWords();

    result.fold(
      (f) => fail(f.message),
      (list) {
        expect(list, testEntities);
        expect(list.isNotEmpty, true, reason: "Has data");
      },
    );
  });
}
