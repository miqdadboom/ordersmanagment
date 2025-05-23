import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnimatedIntro extends StatelessWidget {
  const AnimatedIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: AnimatedTextKit(
        displayFullTextOnTap: true,
        isRepeatingAnimation: false,
        repeatForever: false,
        animatedTexts: [
          TyperAnimatedText(
            "Hello, What can I do for you?",
            speed: const Duration(milliseconds: 50),
            textStyle: TextStyle(
              fontFamily: "Cera Pro",
              fontSize: 24,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
