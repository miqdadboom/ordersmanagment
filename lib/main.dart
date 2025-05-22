import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:ordersmanagment_app/features/products/presentation/screens/product_management.dart';
import 'package:ordersmanagment_app/features/products/presentation/screens/products_screen.dart';
import 'package:ordersmanagment_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductsScreen(),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform, // تأكد من وجود هذا
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Sales App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home:
//           ProductManagementScreen(), // ✅ هنا تستخدم ProductManagement داخل MaterialApp
//     );
//   }
// }

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ProductManagement(),
//     ),
//   );
// }
