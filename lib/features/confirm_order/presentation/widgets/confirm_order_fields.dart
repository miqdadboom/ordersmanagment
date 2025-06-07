import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:flutter/material.dart';
import '../../../../../core/widgets/location_input.dart';
import '../../../../../core/widgets/place.dart';

class ConfirmOrderFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController notesController;
  final void Function(PlaceLocation) onLocationSelected;

  const ConfirmOrderFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.notesController,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.03),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name of customer",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            validator: (value) {
              if(value == null || value.trim().isEmpty){
                return 'Please enter customer name';
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.03),
          LocationInput(onSelectLocation: onLocationSelected),
          AppSizedBox.height(context, 0.025),
          TextFormField(
            maxLines: 3,
            controller: notesController,
            decoration: InputDecoration(
              labelText: "Notes",
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            ),
        ],
      ),
    );
  }
}
