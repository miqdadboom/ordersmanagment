import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/startup/firebase_initializer.dart';
import 'core/startup/app_bloc_providers.dart';
import 'core/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  runApp(
    buildBlocProviders(
      child: const ProviderScope(child: MyApp()),
    ),
  );
}
