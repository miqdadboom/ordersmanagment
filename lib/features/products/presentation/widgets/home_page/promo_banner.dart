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
    if (banners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 200,
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
                top: 16,
                left: 16,
                child: Text(
                  banner['title'] ?? '',
                  style: const TextStyle(
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