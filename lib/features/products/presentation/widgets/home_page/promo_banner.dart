import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final List<String> images = [
    'https://images.pexels.com/photos/27085501/pexels-photo-27085501/free-photo-of-overgrown-wall-of-an-apartment-building.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/31887348/pexels-photo-31887348/free-photo-of-elegant-spring-white-flowers-in-bloom.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
    'https://images.pexels.com/photos/15619932/pexels-photo-15619932/free-photo-of-macro-of-green-leaf-on-black-background.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  ];

  late final PageController _pageController;
  final int initialPage = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final image = images[index % images.length];
          return Stack(
            children: [
              Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: AppColors.cloudyOfHeder,
                width: double.infinity,
                height: double.infinity,
              ),
              const Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'New product and offers',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textLight,
                    foregroundColor: AppColors.textDark,
                  ),
                  child: const Text('Shop Now'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
