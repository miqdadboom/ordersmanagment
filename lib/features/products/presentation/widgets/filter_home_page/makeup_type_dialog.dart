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
    return AlertDialog(
      title: const Text('Select Makeup Types'),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              widget.makeupTypes.map((type) {
                final isSelected = tempSelectedTypes.contains(type);
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => handleToggle(type),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color:
                        isSelected ? AppColors.textLight : AppColors.textDark,
                  ),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
