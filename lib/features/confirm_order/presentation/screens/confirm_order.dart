import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/place.dart';
import '../../../map/presentation/widgets/user_place_provider.dart';
import '../widgets/confirm_order_actions.dart';
import '../widgets/confirm_order_fields.dart';
import '../widgets/confirm_order_header.dart';

class ConfirmOrder extends ConsumerStatefulWidget {
  const ConfirmOrder({super.key});

  @override
  ConsumerState<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends ConsumerState<ConfirmOrder> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  PlaceLocation? _selectedLocation;

  void _savePlace(BuildContext context) {
    final customerName = _nameController.text.trim();

    if (_selectedLocation == null || customerName.isEmpty) return;

    ref.read(userPlaceProvider.notifier).addPlace(customerName, _selectedLocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: screenHeight * 0.1),
        child: Center(
          child: Container(
            height: screenHeight * 0.85,
            width: screenWidth * 0.9,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.startConfirmOrder, AppColors.endConfirmOrder],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConfirmOrderHeader(screenWidth: screenWidth),
                ConfirmOrderFields(
                  nameController: _nameController,
                  notesController: _notesController,
                  onLocationSelected: (location) {
                    _selectedLocation = location;
                  },
                ),
                const Spacer(),
                ConfirmOrderActions(onSend: () => _savePlace(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
