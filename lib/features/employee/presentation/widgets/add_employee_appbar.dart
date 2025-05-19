import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;

  const EmployeeAppBar({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
