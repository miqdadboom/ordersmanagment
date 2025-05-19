import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/features/products/presentation/screens/products_screen.dart';

void main() {
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
