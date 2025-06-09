import 'package:final_tasks_front_end/core/constants/app_size_box.dart';
import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import '../../../data/models/promo_banner.dart';
import '../../../data/firebase/promo_banner_repository.dart';

class PromoBannerSlider extends StatelessWidget {
  const PromoBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<List<PromoBannerModel>>(
      stream: PromoBannerRepository().getBanners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load banners'));
        }
        final banners = snapshot.data ?? [];
        if (banners.isEmpty) {
          return const SizedBox();
        }
        return SizedBox(
          height: screenHeight * 0.25,
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(banner.imageUrl, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: Container(color: AppColors.cloudyOfHeder),
                  ),
                  Positioned(
                    top: screenHeight * 0.04,
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                        AppSizedBox.height(context, 0.01),
                        Text(
                          banner.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(1, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.03,
                    right: screenWidth * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/products');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.045,
                          vertical: screenHeight * 0.012,
                        ),
                        elevation: 2,
                        textStyle: TextStyle(
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: const Text('Shop Now'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
