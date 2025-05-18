import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/chat_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/conversations_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/map/presentation/screens/map_screen.dart';
import 'features/product/presentation/cart_screen/screens/cart_screen.dart';
import 'features/confirm_order/presentation/screens/confirm_order.dart';
import 'features/product/presentation/product_view/screens/product_view.dart';

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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
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
