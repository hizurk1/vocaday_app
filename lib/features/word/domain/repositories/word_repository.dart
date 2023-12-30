import '../../../../../core/typedef/typedefs.dart';
import '../entities/word_entity.dart';

abstract interface class WordRepository {
  FutureEither<List<WordEntity>> getAllWords();
}
