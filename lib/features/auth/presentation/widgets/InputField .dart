import 'package:flutter/material.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_size_box.dart';

class InputField extends StatefulWidget {
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
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: isWideScreen ? 25 : 20,
                left: isWideScreen ? 20 : 0,
                right: isWideScreen ? 20 : 0,
              ),
              child: TextFormField(
                controller: widget.controller,
                obscureText: _obscure,
                style: AppTextStyles.bodySuggestion(context).copyWith(
                  color: widget.textColor,
                  fontSize: isWideScreen ? 16 : 14,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the field';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: isWideScreen ? 24 : 20,
                  ),
                  hintText: widget.hint,
                  hintStyle: AppTextStyles.bodySuggestion(context).copyWith(
                    color: widget.textColor.withOpacity(0.6),
                    fontSize: isWideScreen ? 16 : 14,
                  ),
                  filled: true,
                  fillColor: widget.fillColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isWideScreen ? 20 : 15,
                    vertical: isWideScreen ? 20 : 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isWideScreen ? 20 : 15),
                    borderSide: BorderSide(color: widget.borderColor, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isWideScreen ? 20 : 15),
                    borderSide: BorderSide(color: widget.borderColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isWideScreen ? 20 : 15),
                    borderSide: BorderSide(color: widget.borderColor, width: 2),
                  ),
                  suffixIcon: widget.obscureText
                      ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: widget.iconColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                      : null,
                ),
              ),
            ),
            AppSizedBox.height(context, 0.0001),
          ],
        );
      },
    );
  }
}
