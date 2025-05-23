import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/chat_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/conversations_screen.dart';
import 'package:final_tasks_front_end/features/chat_bot/presentation/screens/home_screen.dart';
import 'package:final_tasks_front_end/features/map/presentation/screens/map_screen.dart';
import 'package:final_tasks_front_end/features/orders/domain/entities/order_product.dart' as order_product;
import 'package:final_tasks_front_end/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:final_tasks_front_end/features/orders/presentation/screens/list_of_orders_screen.dart';
import 'package:final_tasks_front_end/features/product/presentation/cart_screen/screens/cart_screen.dart';
import 'package:final_tasks_front_end/features/confirm_order/presentation/screens/confirm_order.dart';
import 'package:final_tasks_front_end/features/product/presentation/product_view/screens/product_view.dart';
import 'package:final_tasks_front_end/features/products/presentation/screens/order_products_screen.dart';
import 'package:final_tasks_front_end/features/orders/data/datasources/order_data_source_impl.dart';
import 'package:final_tasks_front_end/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:final_tasks_front_end/features/orders/domain/repositories/orders_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/orders/domain/repositories/orders_repository_impl.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final dataSource = OrderDataSourceImpl();
  final OrderRepository repository = OrderRepositoryImpl(dataSource: dataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OrdersCubit>(create: (_) => OrdersCubit(repository)..loadOrders()),
      ],
      child: const ProviderScope(child: MyApp()),
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
        '/homeScreen': (context) => const HomeScreen(),
        '/conversationScreen': (context) => const ConversationsScreen(),
        '/chatScreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ChatScreen(conversationId: args['id']);
        },
        '/mapScreen': (context) => const MapScreen(),
        '/confirmOrder': (context) {
          final products = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;
          return ConfirmOrder(cartProducts: products);
        },
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
      onGenerateRoute: (settings) {
        if (settings.name == '/products') {
          final args = settings.arguments as List<order_product.OrderProduct>;
          return MaterialPageRoute(
            builder: (context) => OrderProductsScreen(products: args),
          );
        }

        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }
}
