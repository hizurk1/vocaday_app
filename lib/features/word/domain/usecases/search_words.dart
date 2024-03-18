import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../../core/typedef/typedefs.dart';
import '../../../../../core/usecases/usecases.dart';
import '../../../../app/constants/app_const.dart';
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
    const maxSimilarItem = AppValueConst.maxItemLoad;

    final getAllWordsResult = await repository.getAllWords();

    return getAllWordsResult.fold(
      (fail) => Left(fail),
      (wordList) {
        final searchResult = wordList
            .where(
              (entity) => entity.word.contains(keyword),
            )
            .toList()
          ..sort((a, b) => a.word.length.compareTo(b.word.length));

        if (keyword.length < 3) {
          return Right((searchResult, []));
        } else {
          return Right((
            searchResult,
            _findSimilarWords(keyword, wordList, searchResult)
                .take(maxSimilarItem)
                .toList(),
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
        final int step = SearchAlgorithm.calculateWagnerFischer(
          keyword,
          entity.word,
        );
        if (1 <= step && step <= min(2, keyword.length - 2)) {
          results[entity] = step;
        }
      }
    }

    List<WordEntity> sortedList = results.keys.toList()
      ..sort((a, b) => results[b]!.compareTo(results[a]!));

    return sortedList;
  }
}
