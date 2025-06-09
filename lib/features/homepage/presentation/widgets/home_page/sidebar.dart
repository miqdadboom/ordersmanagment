import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Column(
        children: [
          Container(
            color: AppColors.primary,
            padding: EdgeInsets.only(
              left: screenWidth * 0.04, // ~16
              right: screenWidth * 0.04,
              top: screenHeight * 0.09, // ~70
              bottom: screenHeight * 0.025, // ~20
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.075, // ~30
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?img=3',
                  ),
                ),
                AppSizedBox.width(context, 0.04),
                Expanded(
                  child: Text(
                    'Ahmad istatieh',
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: screenWidth * 0.055, // ~22
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
                    size: screenWidth * 0.06,
                  ),
                  title: Text(
                    'Chatbot',
                    style: TextStyle(
                      color: AppColors.icon,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/homeScreen');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_box_outlined,
                    color: AppColors.icon,
                    size: screenWidth * 0.06,
                  ),
                  title: Text(
                    'Add Product',
                    style: TextStyle(
                      color: AppColors.icon,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/ProductManagementScreen');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.category,
                    color: AppColors.icon,
                    size: screenWidth * 0.06,
                  ),
                  title: Text(
                    'Category Management',
                    style: TextStyle(
                      color: AppColors.icon,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/CategoryManagementScreen');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.campaign,
                    color: AppColors.icon,
                    size: screenWidth * 0.06,
                  ),
                  title: Text(
                    'Promo Banner Management',
                    style: TextStyle(
                      color: AppColors.icon,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/PromoBannerManagementScreen',
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              bottom: screenHeight * 0.06, // ~50
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
            ),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: AppColors.lougOut,
                size: screenWidth * 0.06,
              ),
              title: Text(
                'Log out',
                style: TextStyle(
                  color: AppColors.lougOut,
                  fontSize: screenWidth * 0.045,
                ),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06, // ~24
                                vertical: screenHeight * 0.015, // ~12
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.02,
                                ), // ~8
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Log out'),
                          ),
                          AppSizedBox.width(context, 0.03),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.cancel,
                              side: const BorderSide(
                                color: AppColors.cancelField,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: screenHeight * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.02,
                                ), // ~8
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
