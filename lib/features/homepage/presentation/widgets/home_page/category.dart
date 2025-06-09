import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:final_tasks_front_end/features/homepage/domain/entities/category.dart';
import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final Function(int index) onCategoryTap;
  final VoidCallback onViewAllTap;
  final List<Category> categories;

  const CategorySection({
    super.key,
    required this.onCategoryTap,
    required this.onViewAllTap,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // تقريبًا 16
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // تقريبًا 24
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, // تقريبًا 14
                    color: AppColors.viewAll,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height:
              MediaQuery.of(context).size.height *
              0.12, // تقريبًا 100 على شاشة 800
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                ), // تقريبًا 8
                child: GestureDetector(
                  onTap: () => onCategoryTap(index),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth * 0.2, // تقريبًا 80 على شاشة 400
                        height: screenWidth * 0.2,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(category.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSizedBox.height(context, 0.0075),
                      Text(
                        category.name,
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: screenWidth * 0.025, // تقريبًا 10
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
