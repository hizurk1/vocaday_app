import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vocaday_app/features/word/data/data_sources/word_local_data_source.dart';
import 'package:vocaday_app/features/word/data/models/word_model.dart';
import 'package:vocaday_app/features/word/data/repositories/word_repository_impl.dart';

class MockWordLocalDataSource extends Mock implements WordLocalDataSource {}

void main() {
  late WordRepositoryImpl wordRepositoryImpl;
  late MockWordLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWordLocalDataSource();
    wordRepositoryImpl = WordRepositoryImpl(localDataSource: mockDataSource);
  });

  final testModels = [
    const WordModel(
      word: 'word',
      meanings: [
        MeaningModel(
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

  group('Word Repository', () {
    test('should get list of word model from local data source', () async {
      when(() => mockDataSource.getAllWords())
          .thenAnswer((_) async => testModels);

      final result = await wordRepositoryImpl.getAllWords();

      result.fold(
        (f) => fail(f.message),
        (list) {
          expect(list.isNotEmpty, true, reason: "Has data");
        },
      );
    });
  });
}
