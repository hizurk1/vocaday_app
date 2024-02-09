import 'package:fpdart/fpdart.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/typedef/typedefs.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/word_repository.dart';
import '../data_sources/word_local_data_source.dart';

class WordRepositoryImpl implements WordRepository {
  final WordLocalDataSource localDataSource;

  const WordRepositoryImpl({required this.localDataSource});

  @override
  FutureEither<List<WordEntity>> getAllWords() async {
    try {
      final wordList = await localDataSource.getAllWords();

      return Right(
        wordList.map((e) => e.toEntity()).toList(),
      );
    } catch (e) {
      return Left(
        UnknownFailure(e.toString()),
      );
    }
  }
}
