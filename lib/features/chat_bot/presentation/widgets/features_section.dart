import 'package:final_tasks_front_end/features/chat_bot/presentation/widgets/suggestion_box.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Here are some features",
            style: TextStyle(
              fontFamily: "Cera Pro",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
        ),
        SuggetionBox(
          header: "Ask For Information",
          body: "Feel free to ask whatever goes in your mind",
          color: AppColors.suggestionBox1,
        ),
        SuggetionBox(
          header: "Powerful AI",
          body: "Giving facts and up-to-date information with a trained AI bot",
          color: AppColors.suggestionBox2,
        ),
        SuggetionBox(
          header: "Fast and Accurate",
          body: "Our model is trained to be as fast and accurate as possible",
          color: AppColors.suggestionBox3,
        ),
      ],
    );
  }
}
