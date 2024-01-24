import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/utils/search_algorithm.dart';
import '../entities/word_entity.dart';
import '../repositories/word_repository.dart';

class SearchWordsUsecase extends Usecases<
    (List<WordEntity> sameWords, List<WordEntity> similarWords),
    (String keyword, List<WordEntity>)> {
  final WordRepository repository;

  SearchWordsUsecase({required this.repository});

  @override
  FutureEither<(List<WordEntity> sameWords, List<WordEntity> similarWords)>
      call(
    (String keyword, List<WordEntity>) params,
  ) async {
    final keyword = params.$1.toUpperCase();
    final list = params.$2;
    int maxAmount = 10;

    final searchResult = list
        .where(
          (object) => object.word.contains(keyword),
        )
        .take(maxAmount)
        .toList();

    if (keyword.length < 3) {
        return Right((searchResult, []));
    } else {
        return Right((
        searchResult,
        _findSimilarWords(keyword, list).take(maxAmount).toList()
      ));
    }
  }

  List<WordEntity> _findSimilarWords(
    String keyword,
    List<WordEntity> wordList,
  ) {
    final results = wordList.fold<Map<String, int>>(
      {},
      (previousMap, element) {
        if (element.word.length >= keyword.length) {
          final int steps = SearchAlgorithm.calculateWagnerFischer(
            keyword,
            element.word,
          );
          if (steps <= keyword.length ~/ 2) {
            previousMap[element.word] = steps;
          }
        }
        return previousMap;
      },
    );

    List<WordEntity> sortedList = wordList
        .where((entity) => results.containsKey(entity.word))
        .toList()
      ..sort((a, b) => results[b.word]!.compareTo(results[a.word]!));

    return sortedList;
  }
}
