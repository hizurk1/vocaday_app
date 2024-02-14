// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../domain/entities/word_entity.dart';

class WordModel {
  final String word;
  final List<MeaningModel> meanings;
  final List<String> synonyms;
  final List<String> antonyms;

  const WordModel({
    required this.word,
    required this.meanings,
    required this.synonyms,
    required this.antonyms,
  });

  WordModel copyWith({
    String? word,
    List<MeaningModel>? meanings,
    List<String>? synonyms,
    List<String>? antonyms,
  }) {
    return WordModel(
      word: word ?? this.word,
      meanings: meanings ?? this.meanings,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
    );
  }

  factory WordModel.fromJson(Map<String, dynamic> json) {
    final word = json.keys.first;
    final meanings = json[word]["MEANINGS"] as List<dynamic>;
    return WordModel(
      word: word,
      meanings: meanings.isNotEmpty
          ? meanings
              .map((list) => MeaningModel.fromList(list as List<dynamic>))
              .toList()
          : [],
      synonyms: List<String>.from(json[word]["SYNONYMS"]),
      antonyms: List<String>.from(json[word]["ANTONYMS"]),
    );
  }

  static List<WordModel> fromRawJsonToListModel(Map<String, dynamic> raw) {
    return raw.entries
        .map((entry) => {entry.key: entry.value})
        .map((json) => WordModel.fromJson(json))
        .toList();
  }

  Map<String, Map<String, dynamic>> toJson() {
    return {
      word: {
        "MEANINGS": meanings.map((list) => list.toMeaningList()).toList(),
        "ANTONYMS": antonyms,
        "SYNONYMS": synonyms,
      },
    };
  }

  WordEntity toEntity() => WordEntity(
        word: word,
        meanings: meanings.map((e) => e.toEntity()).toList(),
        synonyms: synonyms,
        antonyms: antonyms,
      );
}

class MeaningModel {
  final String type;
  final String meaning;
  final List<String> synonyms;
  final List<String> examples;

  const MeaningModel({
    required this.type,
    required this.meaning,
    required this.synonyms,
    required this.examples,
  });

  factory MeaningModel.fromList(List<dynamic> meaningData) {
    return MeaningModel(
      type: meaningData[0],
      meaning: meaningData[1],
      synonyms: List<String>.from(meaningData[2]),
      examples: List<String>.from(meaningData[3]),
    );
  }

  List<dynamic> toMeaningList() {
    return [type, meaning, synonyms, examples];
  }

  MeaningEntity toEntity() => MeaningEntity(
        type: type,
        meaning: meaning,
        synonyms: synonyms,
        examples: examples,
      );
}
