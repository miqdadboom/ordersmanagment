import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Color borderColor;
  final Color fillColor;
  final Color iconColor;
  final Color textColor;

  const InputField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    required this.borderColor,
    required this.fillColor,
    required this.iconColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: textColor),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the field';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor),
          hintText: hint,
          hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
        ),
      ),
    );
  }
}