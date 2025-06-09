// import 'package:flutter/material.dart';

// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories'),
//         leading: IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('إدارة التصنيفات'),
//               onTap: () {
//                 Navigator.pop(context); // إغلاق القائمة الجانبية
//                 Navigator.pushNamed(context, '/CategoryManagementScreen');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: const Center(child: Text('Categories Screen')),
//     );
//   }
// }
