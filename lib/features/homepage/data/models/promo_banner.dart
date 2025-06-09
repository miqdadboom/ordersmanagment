import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/promo_banner.dart';

class PromoBannerModel extends PromoBanner {
  PromoBannerModel({
    required String id,
    required String title,
    required String description,
    required String imageUrl,
    required DateTime createdAt,
  }) : super(
         id: id,
         title: title,
         description: description,
         imageUrl: imageUrl,
         createdAt: createdAt,
       );

  factory PromoBannerModel.fromMap(Map<String, dynamic> map, String id) {
    final title = map['title'] ?? map['caption'] ?? '';
    final description = map['description'] ?? '';
    return PromoBannerModel(
      id: id,
      title: title,
      description: description,
      imageUrl: map['imageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
