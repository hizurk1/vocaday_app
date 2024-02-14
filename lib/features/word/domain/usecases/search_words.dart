import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/utils/search_algorithm.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class SearchWordsUsecase
    extends Usecases<(List<WordEntity>, List<WordEntity>), String> {
  final WordRepository repository;

  SearchWordsUsecase({required this.repository});

  @override
  FutureEither<(List<WordEntity> sameWords, List<WordEntity> similarWords)>
      call(
    String params,
  ) async {
    final keyword = params.toUpperCase();
    int maxAmount = 20;

    final getAllWordsResult = await repository.getAllWords();

    return getAllWordsResult.fold(
      (fail) => Left(fail),
      (wordList) {
        final searchResult = wordList
            .where(
              (object) => object.word.contains(keyword),
            )
            .toList();

        if (keyword.length < 3) {
          return Right((searchResult.take(maxAmount).toList(), []));
        } else {
          return Right((
            searchResult.take(maxAmount).toList(),
            _findSimilarWords(keyword, wordList, searchResult)
                .take(maxAmount ~/ 2)
                .toList()
          ));
        }
      },
    );
  }

  List<WordEntity> _findSimilarWords(
    String keyword,
    List<WordEntity> wordList,
    List<WordEntity> searchResult,
  ) {
    Map<WordEntity, int> results = {};

    for (WordEntity entity in wordList) {
      if (!searchResult.contains(entity) &&
          keyword.length <= entity.word.length &&
          entity.word.length <= keyword.length * 2) {
        final int steps = SearchAlgorithm.calculateWagnerFischer(
          keyword,
          entity.word,
        );
        if (steps <= keyword.length ~/ 2) {
          results[entity] = steps;
        }
      }
    }

    List<WordEntity> sortedList = results.keys.toList()
      ..sort((a, b) => results[b]!.compareTo(results[a]!));

    return sortedList;
  }
}
