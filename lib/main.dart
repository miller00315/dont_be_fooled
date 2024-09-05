import 'dart:async';

import 'package:dont_be_fooled/app/app.dart';
import 'package:dont_be_fooled/app/core/bloc_observer/bloc_observer.dart';
import 'package:dont_be_fooled/app/injector.dart';
import 'package:dont_be_fooled/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get_it/get_it.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

GetIt getIt = GetIt.instance;

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      if (Firebase.apps.isEmpty) {
        app = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        app = Firebase.app();
      }

      auth = FirebaseAuth.instanceFor(app: app);

      getIt.registerLazySingleton<FirebaseAuth>(() => auth);

      injectDependencies(getIt);

      Gemini.init(
        apiKey: const String.fromEnvironment('ia_api_key'),
        enableDebugging: true,
      );

      Bloc.observer = AppBlocObserver();

      runApp(App());
    },
    (error, stack) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stack);
    },
  );
}
