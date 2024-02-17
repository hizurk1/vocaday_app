import 'dart:math';

extension ListExt<T> on List<T> {
  T? get getRandom {
    if (isEmpty) return null;
    int rand = Random().nextInt(length);
    return this[rand];
  }
}

extension ListNullExt<T> on List<T>? {
  bool get isNotNullOrEmpty {
    if (this == null) {
      return false;
    } else {
      return this!.isNotEmpty;
    }
  }

  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    } else {
      return this!.isEmpty;
    }
  }
}
