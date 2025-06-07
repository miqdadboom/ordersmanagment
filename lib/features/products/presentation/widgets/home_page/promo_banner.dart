import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  late final PageController _pageController;
  final int initialPage = 10000;
  List<Map<String, dynamic>> banners = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: initialPage);
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('promo_banners').get();

    setState(() {
      banners = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (banners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: screenHeight * 0.25, // بدل 200
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index % banners.length];

          return Stack(
            children: [
              Image.network(
                banner['imageUrl'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                color: AppColors.cloudyOfHeder,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                top: screenHeight * 0.02, // بدل 16
                left: screenWidth * 0.04,
                child: Text(
                  banner['title'] ?? '',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: screenWidth * 0.05, // بدل 20
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.02,
                right: screenWidth * 0.04,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textLight,
                    foregroundColor: AppColors.textDark,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.012,
                    ),
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.035, // حجم نص الزر
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
  }
}
