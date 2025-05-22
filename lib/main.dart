import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/chat_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/conversations_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/map/presentation/screens/map_screen.dart';
import 'features/cart_product/presentation/cart_screen/screens/cart_screen.dart';
import 'features/confirm_order/presentation/screens/confirm_order.dart';
import 'features/products/presentation/screens/products_screen.dart';
import 'features/products/product_view/screens/product_view.dart';
import 'features/employee/presentation/screens/add_employee_screen.dart';
import 'features/employee/presentation/screens/edit_employee_screen.dart';
import 'features/employee/presentation/screens/manage_employee_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/products/presentation/screens/filter_products.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/productScreen': (context) => ProductsScreen(),
        '/filterProductScreen': (context) => FilterProductsScreen(),
        '/login': (context) => LoginScreen(),
        '/manage': (context) => ManageEmployee(),
        '/add': (context) => const AddEmployee(),
        '/edit': (context) => const EditEmployee(),
        '/homeScreen': (context) => const HomeScreen(),
        '/conversationScreen': (context) => const ConversationsScreen(),
        '/chatScreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ChatScreen(conversationId: args['id']);
        },
        '/mapScreen': (context) => const MapScreen(),
        '/confirmOrder': (context) => const ConfirmOrder(),
        '/cartScreen': (context) => const CartScreen(),
        '/productView': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ProductView(
            imageUrl: args['imageUrl'],
            name: args['name'],
            brand: args['brand'],
            price: args['price'],
          );
        },
      },
    );
  }
}