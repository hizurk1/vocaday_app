import 'dart:math';

extension ListExt<T> on List<T> {
  T? get getRandom {
    if (isEmpty) return null;
    int rand = Random().nextInt(length);
    return this[rand];
  }
}
