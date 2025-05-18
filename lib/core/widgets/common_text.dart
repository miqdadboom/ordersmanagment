
import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double size;
  final bool isBold;
  final Color color;

  const CommonText({
    super.key,
    required this.text,
    this.size = 16,
    this.isBold = false,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }
}
