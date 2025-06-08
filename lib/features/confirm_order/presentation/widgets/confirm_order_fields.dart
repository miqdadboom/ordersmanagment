import 'package:flutter/material.dart';
import '../../../../../core/widgets/build_text_field.dart';
import '../../../../../core/widgets/location_input.dart';
import '../../../../../core/widgets/place.dart'; // تأكد من استيراد PlaceLocation

class ConfirmOrderFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController notesController;
  final void Function(PlaceLocation) onLocationSelected;

  const ConfirmOrderFields({
    super.key,
    required this.nameController,
    required this.notesController,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.03),
        BuildTextField(
          hint: "Name of customer",
          controller: nameController,
        ),
        SizedBox(height: screenHeight * 0.03),
        LocationInput(onSelectLocation: onLocationSelected),
        const SizedBox(height: 20),
        BuildTextField(
          hint: "Notes (optional)",
          maxLines: 3,
          controller: notesController,
        ),
      ],
    );
  }
}
