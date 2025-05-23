import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/employee/presentation/screens/add_employee_screen.dart';
import 'features/employee/presentation/screens/edit_employee_screen.dart';
import 'features/employee/presentation/screens/manage_employee_screen.dart';
import 'features/orders/data/models/order_model.dart';
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

//   final dataSource = OrderDataSourceImpl();
//   final OrderRepository repository = OrderRepositoryImpl(dataSource: dataSource);
//
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider<OrdersCubit>(create: (_) => OrdersCubit(repository)..loadOrders()),
//       ],
//       child: const ProviderScope(child: MyApp()),
//     ),
//   );
// }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        // '/listOrder': (context) => ListOfOrdersScreen(),
        // '/products': (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments;
        //   final products = args is List<order_product.OrderProduct> ? args : <order_product.OrderProduct>[];
        //   return OrderProductsScreen(products: products);
        // },
        // '/orderScreen': (context) {
        //   final order = ModalRoute.of(context)!.settings.arguments as OrderEntity;
        //   return OrderDetailsScreen(order: order);
        // },
        // '/productScreen': (context) => ProductsScreen(),
        // '/filterProductScreen': (context) => FilterProductsScreen(),
        '/login': (context) => LoginScreen(),
        '/manage': (context) => ManageEmployee(),
        '/add': (context) => const AddEmployee(),
        '/edit': (context) => const EditEmployee(userId: '',),
        // '/homeScreen': (context) => const HomeScreen(),
        // '/conversationScreen': (context) => const ConversationsScreen(),
        // '/chatScreen': (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        //   return ChatScreen(conversationId: args['id']);
        // },
        // '/mapScreen': (context) => const MapScreen(),
        // '/confirmOrder': (context) {
        //   final products = ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>;
        //   return ConfirmOrder(cartProducts: products);
        // },
        // '/cartScreen': (context) => const CartScreen(),
        // '/productView': (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        //   return ProductView(
        //     imageUrl: args['imageUrl'],
        //     name: args['name'],
        //     brand: args['brand'],
        //     price: args['price'],
        //   );
        // },
      },
    );
  }
}
