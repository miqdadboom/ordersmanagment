import 'package:flutter/material.dart';

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
              child: const Text('view all'),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: makeupTypes.map((type) {
                final isSelected = selectedTypes.contains(type);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) => onTypeSelected(type),
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

