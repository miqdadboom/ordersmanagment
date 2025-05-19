import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/constants/app_colors.dart';

class MakeupTypeFilter extends StatelessWidget {
  final List<String> makeupTypes;
  final Set<String> selectedTypes;
  final Function(String) onTypeSelected;
  final VoidCallback onViewAllPressed;

  const MakeupTypeFilter({
    super.key,
    required this.makeupTypes,
    required this.selectedTypes,
    required this.onTypeSelected,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Type of Makeup',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewAllPressed,
              child: const Text(
                'view all',
                style: TextStyle(color: AppColors.textDark),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  makeupTypes.map((type) {
                    final isSelected = selectedTypes.contains(type);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => onTypeSelected(type),
                        selectedColor:
                            AppColors.primary, // لون الخلفية عند التحديد
                        backgroundColor: Colors.grey[100], // لون الخلفية العادي
                        checkmarkColor: Colors.white, // لون علامة الاختيار
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        elevation: 2, // ظل خفيف
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
