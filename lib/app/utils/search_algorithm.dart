import 'dart:math';

class SearchAlgorithm {
  SearchAlgorithm._();
  static int calculateWagnerFischer(String a, String b) {
    final int m = a.length;
    final int n = b.length;

    if (m == 0) return n;
    if (n == 0) return m;

    List<int> curRow = List<int>.generate(n + 1, (int i) => i);

    int previous;

    for (int i = 1; i <= m; i++) {
      previous = curRow[0];
      curRow[0] = i;
      for (int j = 1; j <= n; j++) {
        int temp = curRow[j];
        if (a[i - 1] == b[j - 1]) {
          curRow[j] = previous;
        } else {
          curRow[j] = min(previous, min(curRow[j - 1], curRow[j])) + 1;
        }
        previous = temp;
      }
    }

    return curRow[n];
  }
}
