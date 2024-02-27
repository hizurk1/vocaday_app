import 'package:flutter/material.dart';

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
      path: "assets/translations",
      fallbackLocale: AppLocale.en.instance,
      child: AppLifeCycleListenerWidget(
        child: child,
      ),
    );
  }
}
