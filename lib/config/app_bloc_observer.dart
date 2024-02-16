import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      logger.i('${bloc.runtimeType} created');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      logger.i(
        '${bloc.runtimeType} changed from [${change.currentState.runtimeType}] to [${change.nextState.runtimeType}]',
      );
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      logger.i('$event is added to ${bloc.runtimeType}');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      logger.e(
        '${bloc.runtimeType} has errors.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      logger.i('${bloc.runtimeType} is closed');
    }
  }
}
