import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class EmployeeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final String validatorMessage;
  final Color primaryColor;
  final bool isPassword;

  const EmployeeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.validatorMessage,
    this.primaryColor = AppColors.primary,
    this.isPassword = false,
  });

  @override
  State<EmployeeTextField> createState() => _EmployeeTextFieldState();
}

class _EmployeeTextFieldState extends State<EmployeeTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscure : false,
        validator: (value) =>
        (value == null || value.trim().isEmpty) ? widget.validatorMessage : null,
        style: AppTextStyles.bodySuggestion(context),
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: widget.primaryColor),
          suffixIcon: widget.isPassword
              ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: widget.primaryColor,
            ),
            onPressed: () => setState(() => _obscure = !_obscure),
          )
              : null,
          hintText: widget.hintText,
          hintStyle: AppTextStyles.bodySuggestion(context).copyWith(
            color: AppColors.textDescription,
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: widget.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(color: Colors.red.shade600, width: 2),
          ),
        ),
      ),
    );
  }
}
