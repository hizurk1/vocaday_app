import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/transformers.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// Create debounce (delay by default = 300ms):
/// ```dart
/// Debouncer _debounce = Debouncer();
/// ```
/// Don't forget to dispose it on dispose state.
/// ```dart
/// _debounce.dispose();
/// ```
/// Usage:
/// ```dart
/// _debounce.run(() => yourFunction());
/// ```
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 300});

  void run(Function() action) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
