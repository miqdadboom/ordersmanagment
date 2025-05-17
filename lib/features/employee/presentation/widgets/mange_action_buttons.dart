import 'package:flutter/material.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback onAddPressed;
  final ValueChanged<String> onSortSelected;

  const ActionButtonsWidget({
    super.key,
    required this.onAddPressed,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.person_add),
            label: const Text("Add Employee", style: TextStyle(color: Colors.black)),
            onPressed: onAddPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39A28B),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39A28B),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: PopupMenuButton<String>(
              onSelected: onSortSelected,
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Sort", style: TextStyle(color: Colors.black, fontSize: 18)),
                  SizedBox(width: 20),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'name_asc', child: Text('Name A-Z')),
                PopupMenuItem(value: 'name_desc', child: Text('Name Z-A')),
                PopupMenuItem(value: 'job_asc', child: Text('Job A-Z')),
                PopupMenuItem(value: 'job_desc', child: Text('Job Z-A')),
                PopupMenuItem(value: 'reset', child: Text('Reset to Original')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
