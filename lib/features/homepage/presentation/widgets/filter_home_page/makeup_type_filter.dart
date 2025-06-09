import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Type of Makeup',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04, // ~16
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewAllPressed,
              child: Text(
                'view all',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: screenWidth * 0.035, // ~14
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenHeight * 0.05, // ~40
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  makeupTypes.map((type) {
                    final isSelected = selectedTypes.contains(type);
                    return Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.02), // ~8
                      child: FilterChip(
                        label: Text(
                          type,
                          style: TextStyle(
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => onTypeSelected(type),
                        selectedColor: AppColors.primary,
                        backgroundColor: Colors.grey[100],
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.05,
                          ), // ~20
                          side: BorderSide(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        elevation: 1.5, // Slightly smaller than 2
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03, // ~12
                          vertical: screenHeight * 0.005, // ~4
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
