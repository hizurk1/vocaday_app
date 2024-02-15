import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_logger.dart';

class AppLifeCycleListenerWidget extends StatefulWidget {
  const AppLifeCycleListenerWidget({super.key, required this.child});

  final Widget child;

  @override
  State<AppLifeCycleListenerWidget> createState() =>
      _AppLifeCycleListenerWidgetState();
}

class _AppLifeCycleListenerWidgetState
    extends State<AppLifeCycleListenerWidget> {
  late AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(
      onStateChange: _onStateChange,
      onRestart: _onRestart,
    );
  }

  _onStateChange(AppLifecycleState state) {
    if (kDebugMode) {
      logger.t(state.toString());
    }
  }

  _onRestart() {}

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }
}
