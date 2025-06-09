import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class MakeupTypeDialog extends StatefulWidget {
  final List<String> makeupTypes;
  final Set<String> selectedTypes;
  final Function(String) onTypeToggle;

  const MakeupTypeDialog({
    super.key,
    required this.makeupTypes,
    required this.selectedTypes,
    required this.onTypeToggle,
  });

  @override
  State<MakeupTypeDialog> createState() => _MakeupTypeDialogState();
}

class _MakeupTypeDialogState extends State<MakeupTypeDialog> {
  late Set<String> tempSelectedTypes;

  @override
  void initState() {
    super.initState();
    tempSelectedTypes = {...widget.selectedTypes};
  }

  void handleToggle(String type) {
    setState(() {
      if (type == 'all') {
        tempSelectedTypes = {'all'};
      } else {
        tempSelectedTypes.remove('all');
        if (tempSelectedTypes.contains(type)) {
          tempSelectedTypes.remove(type);
        } else {
          tempSelectedTypes.add(type);
        }
      }
      if (tempSelectedTypes.isEmpty) {
        tempSelectedTypes = {'all'};
      }
    });

    widget.onTypeToggle(type);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: Text(
        'Select Makeup Types',
        style: TextStyle(
          fontSize: screenWidth * 0.05, 
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: screenWidth * 0.02, 
          runSpacing: screenHeight * 0.01, 
          children:
              widget.makeupTypes.map((type) {
                final isSelected = tempSelectedTypes.contains(type);
                return ChoiceChip(
                  label: Text(
                    type,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, 
                      color:
                          isSelected ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) => handleToggle(type),
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(
              fontSize: screenWidth * 0.04, 
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
