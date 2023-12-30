import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'bloc_provider_scope.dart';
import 'config/app_bloc_observer.dart';
import 'firebase_options.dart';
import 'global_widget.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.setUpServiceLocator();
  runApp(
    const BlocProviderScope(
      child: GlobalWidget(
        child: MainApp(),
      ),
    ),
  );
}
