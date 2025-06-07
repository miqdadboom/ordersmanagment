import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
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
            style: AppTextStyles.headerConversation(context),
          ),
        ),

        SuggestionBox(
          header: "Ask For Information",
          body: "Feel free to ask whatever goes in your mind",
          color: AppColors.suggestionBox1,
        ),
        SuggestionBox(
          header: "Powerful AI",
          body: "Giving facts and up-to-date information with a trained AI bot",
          color: AppColors.suggestionBox2,
        ),
        SuggestionBox(
          header: "Fast and Accurate",
          body: "Our model is trained to be as fast and accurate as possible",
          color: AppColors.suggestionBox3,
        ),
      ],
    );
  }
}
