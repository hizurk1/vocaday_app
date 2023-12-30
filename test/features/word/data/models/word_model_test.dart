import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:vocaday_app/features/word/data/models/word_model.dart';
import 'package:vocaday_app/features/word/domain/entities/word_entity.dart';

import '../../../../helper/file_reader.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  const tModel = WordModel(
    word: "TEST",
    meanings: [
      MeaningModel(
        type: "Noun",
        meaning: "test meaning",
        synonyms: ["Test", "test"],
        examples: ["test example"],
      )
    ],
    synonyms: ["test"],
    antonyms: [],
  );

  const tEntity = WordEntity(
    word: "TEST",
    meanings: [
      MeaningEntity(
        type: "Noun",
        meaning: "test meaning",
        synonyms: ["Test", "test"],
        examples: ["test example"],
      )
    ],
    synonyms: ["test"],
    antonyms: [],
  );

  final tJson = {
    "TEST": {
      "MEANINGS": [
        [
          "Noun",
          "test meaning",
          ["Test", "test"],
          ["test example"]
        ]
      ],
      "SYNONYMS": ["test"],
      "ANTONYMS": []
    }
  };

  group('Word Model', () {
    test('should get a single model from json', () {
      final json =
          jsonDecode(TestHelper.readJson('test/assets/data/data.json'));
      final result = WordModel.fromJson(json);

      expect(result.word, "C");
      expect(result.meanings.isNotEmpty, true);
    });

    test('should get a list model from json', () {
      final Map<String, dynamic> raw =
          jsonDecode(TestHelper.readJson('test/assets/data/data.json'));
      final result = WordModel.fromRawJsonToListModel(raw);

      expect(result.length, 3, reason: "The raw data has 3 words");
      expect(result[1].word, "COLD");
    });

    test('should get json from model', () {
      expect(tModel.toJson(), tJson);
    });

    test('should get entity from model by convert', () {
      expect(tModel.toEntity(), tEntity);
    });
  });
}
