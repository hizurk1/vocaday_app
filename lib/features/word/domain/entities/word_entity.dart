import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  final String word;
  final List<MeaningEntity> meanings;
  final List<String> synonyms;
  final List<String> antonyms;

  const WordEntity({
    required this.word,
    required this.meanings,
    required this.synonyms,
    required this.antonyms,
  });

  @override
  List<Object?> get props => [word, meanings, synonyms, antonyms];
}

class MeaningEntity extends Equatable {
  final String type;
  final String meaning;
  final List<String> synonyms;
  final List<String> examples;

  const MeaningEntity({
    required this.type,
    required this.meaning,
    required this.synonyms,
    required this.examples,
  });

  @override
  List<Object?> get props => [type, meaning, synonyms, examples];
}
