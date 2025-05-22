import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/category.dart';

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Category',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  'View All',
                  style: TextStyle(fontSize: 14, color: AppColors.viewAll),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () => onCategoryTap(index),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(category.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 10,
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
