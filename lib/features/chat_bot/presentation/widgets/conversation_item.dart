import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';

class ConversationItem extends StatelessWidget {
  final String title;
  final String lastMessage;
  final String lastUpdated;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ConversationItem({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.lastUpdated,
    required this.onTap,
    required this.onDelete,
  });


  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title:  Text('Confirm Deletion',
              style: AppTextStyles.dialogTitle(context),
            ),
            content: const Text(
                'Are you sure you want to delete this conversation?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('Cancel', style: TextStyle(color: AppColors.textDark),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child:  Text(
                    'Delete', style: TextStyle(color: AppColors.iconDelete)),
              ),
            ],
          ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: [
         ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            title,
            style: AppTextStyles.conversationTitle(context),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              lastMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:  AppTextStyles.conversationMessage(context),
            ),
          ),
          trailing: Text(
                lastUpdated,
                style:  AppTextStyles.conversationDate(context),
              ),
              onTap: onTap,
        ),
          Positioned(
            top: 0,
              right: 0,
              child: IconButton(
                  onPressed: () => _showDeleteConfirmation(context),
                  icon: Icon(Icons.close,color: AppColors.icon),
              ),
          ),
      ],
      ),
    );
  }
}
