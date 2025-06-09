import 'package:final_tasks_front_end/features/homepage/data/firebase/promo_banner_repository.dart';
import 'package:final_tasks_front_end/features/homepage/data/models/promo_banner.dart';
import 'package:flutter/material.dart';
import 'promo_banner_card.dart';

class PromoBannerList extends StatelessWidget {
  final Function(PromoBannerModel) onEdit;
  final Function(PromoBannerModel) onDelete;

  const PromoBannerList({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PromoBannerModel>>(
      stream: PromoBannerRepository().getBanners(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final banners = snapshot.data!;
        if (banners.isEmpty) {
          return const Center(child: Text('No banners added yet'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return PromoBannerCard(
              banner: banner,
              onEdit: () => onEdit(banner),
              onDelete: () => onDelete(banner),
            );
          },
        );
      },
    );
  }
}
