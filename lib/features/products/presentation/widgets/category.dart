import 'package:flutter/material.dart';
import 'package:ordersmanagment_app/constants/app_colors.dart';

class CategorySection extends StatelessWidget {
  final Function(int index) onCategoryTap;
  final VoidCallback onViewAllTap; // دالة عند الضغط على View All

  const CategorySection({
    super.key,
    required this.onCategoryTap,
    required this.onViewAllTap,
  });

  final List<String> images = const [
    'https://images.pexels.com/photos/27085501/pexels-photo-27085501/free-photo-of-overgrown-wall-of-an-apartment-building.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/31887348/pexels-photo-31887348/free-photo-of-elegant-spring-white-flowers-in-bloom.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/15619932/pexels-photo-15619932/free-photo-of-macro-of-green-leaf-on-black-background.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  ];

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
                onPressed: onViewAllTap, // استخدم الدالة الجديدة
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text('View All', style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
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
                            image: NetworkImage(images[index % images.length]),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Category ${index + 1}',
                        style: const TextStyle(
                          color: AppColors.categoryName,
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
