import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const LoginButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: isWideScreen ? 55 : 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(isWideScreen ? 25 : 30),
                right: Radius.circular(isWideScreen ? 25 : 30),
              ),
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.4),
                  blurRadius: isWideScreen ? 15 : 20,
                  offset: Offset(0, isWideScreen ? 3 : 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(
                  color: textColor,
                  fontSize: isWideScreen ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isWideScreen ? 1 : 1.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
