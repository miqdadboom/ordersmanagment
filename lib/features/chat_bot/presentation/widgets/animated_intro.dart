import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnimatedIntro extends StatelessWidget {
  const AnimatedIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.035,
      ),
      child: AnimatedTextKit(
        displayFullTextOnTap: true,
        isRepeatingAnimation: false,
        repeatForever: false,
        animatedTexts: [
          TyperAnimatedText(
            "Hello, What can I do for you?",
            speed:  Duration(milliseconds: 50),
            textStyle: AppTextStyles.headerConversation(context),
          ),
        ],
      ),
    );
  }
}
