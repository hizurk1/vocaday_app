import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/build_context.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Platform.isAndroid
            ? context.theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light
            : context.theme.brightness == Brightness.light
                ? Brightness.light
                : Brightness.dark,
      ),
      child: child,
    );
  }
}
