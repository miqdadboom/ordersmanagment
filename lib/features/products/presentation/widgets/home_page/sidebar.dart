import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 70,
              bottom: 20,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=3',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Ahmad istatieh',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.chat_bubble_outline,
                    color: AppColors.icon,
                  ),
                  title: Text(
                    'Chatbot',
                    style: TextStyle(color: AppColors.icon),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/homeScreen');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_box_outlined, color: AppColors.icon),
                  title: Text(
                    'Add Product',
                    style: TextStyle(color: AppColors.icon),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/ProductManagementScreen');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: AppColors.icon),
                  title: Text(
                    'Settings',
                    style: TextStyle(color: AppColors.icon),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, left: 8, right: 8),
            child: ListTile(
              leading: const Icon(Icons.logout, color: AppColors.lougOut),
              title: const Text(
                'Log out',
                style: TextStyle(color: AppColors.lougOut),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text(
                          'Confirm Logout',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Are you sure you want to log out?',
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.logOutField,
                              foregroundColor: AppColors.logOutText,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Log out'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.cancel,
                              side: const BorderSide(
                                color: AppColors.cancelField,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}