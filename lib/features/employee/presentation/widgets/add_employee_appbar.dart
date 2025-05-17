import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/features/employee/presentation/screens/add_employee_screen.dart';


class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;

  const EmployeeAppBar({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployee()),
          );
        },
      ),
      title: null,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 1),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            "Create Employee Account",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
