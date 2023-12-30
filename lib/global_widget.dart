import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/extensions/build_context.dart';
import 'app/constants/app_asset.dart';
import 'app/translations/translations.dart';
import 'config/app_lifecycle_listener.dart';

class GlobalWidget extends StatelessWidget {
  final Widget child;
  const GlobalWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: [AppLocale.en.instance, AppLocale.vi.instance],
      assetLoader: const CodegenLoader(),
      path: AppAssets.translations,
      fallbackLocale: AppLocale.en.instance,
      child: AppLifeCycleListenerWidget(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: _changeBrightnessIcon(context),
          ),
          child: child,
        ),
      ),
    );
  }

  Brightness _changeBrightnessIcon(BuildContext context) {
    return Platform.isAndroid
        ? context.theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light
        : context.theme.brightness == Brightness.light
            ? Brightness.light
            : Brightness.dark;
  }
}
