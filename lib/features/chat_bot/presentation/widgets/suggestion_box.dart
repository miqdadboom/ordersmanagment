// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class SuggestionBox extends StatelessWidget {
  final String header;
  final String body;
  final Color color;
  const SuggestionBox({
    super.key,
    required this.header,
    required this.body,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style:  AppTextStyles.headerSuggestion(context),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(body,
              style: AppTextStyles.bodySuggestion(context),
          ),
        ],
      ),
    );
  }
}