import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';

Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("✅ Firebase initialized");
    } else {
      print("⚠️ Firebase already initialized");
    }
  } catch (e) {
    print("❌ Firebase init error: $e");
  }
}
