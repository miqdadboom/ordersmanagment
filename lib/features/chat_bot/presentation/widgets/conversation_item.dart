import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final String lastMessage;
  final String lastUpdated;
  final VoidCallback onTap;

  const ConversationItem({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.lastUpdated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            lastMessage,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(fontSize: 14, color: AppColors.conversatioTextMessage),
          ),
        ),
        trailing: Text(
          lastUpdated,
          style:  TextStyle(fontSize: 12, color: AppColors.conversatioDateMessage),
        ),
        onTap: onTap,
      ),
    );
  }
}
