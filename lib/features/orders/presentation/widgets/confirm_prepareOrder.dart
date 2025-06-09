// lib/widgets/custom_styled_container.dart
import 'package:flutter/material.dart';

class CustomStyledContainer extends StatelessWidget {
  final Widget? child;

  const CustomStyledContainer({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 296,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF282828), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF39A28B), Color(0xFF80938F)],
        ),
      ),
      child: child,
    );
  }
}
