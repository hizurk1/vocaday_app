import 'package:flutter_test/flutter_test.dart';
import 'package:vocaday_app/app/utils/search_algorithm.dart';

void main() {
  group('Search Algorithm', () {
    test('should return value of Wagner-Fischer algorithm', () {
      expect(SearchAlgorithm.calculateWagnerFischer('becus', 'because'), 2);
    });
    test('should return value of Wagner-Fischer algorithm', () {
      expect(SearchAlgorithm.calculateWagnerFischer('trady', 'trade'), 1);
    });
    test('should return value of Wagner-Fischer algorithm', () {
      expect(SearchAlgorithm.calculateWagnerFischer('trade', 'trade'), 0);
    });
    test('should return value of Wagner-Fischer algorithm', () {
      expect(SearchAlgorithm.calculateWagnerFischer('tryde', 'trady'), 2);
    });
  });
}
