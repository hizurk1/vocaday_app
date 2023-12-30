import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/build_context.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.child,
    this.isDarkBackground = false,
  });

  final Widget child;
  final bool isDarkBackground;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkBackground
            ? context.theme.brightness == Brightness.light
                ? Brightness.light
                : Brightness.dark
            : context.theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
      child: child,
    );
  }
}
