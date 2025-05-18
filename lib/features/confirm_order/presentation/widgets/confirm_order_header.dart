import 'package:flutter/material.dart';
import '../../../../../core/widgets/common_text.dart';

class ConfirmOrderHeader extends StatelessWidget {
  final double screenWidth;
  const ConfirmOrderHeader({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return CommonText(
      text: "You are Confirm this order ?",
      isBold: true,
      size: screenWidth * 0.07,
    );
  }
}
