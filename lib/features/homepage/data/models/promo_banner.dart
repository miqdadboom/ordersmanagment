import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBanner {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  PromoBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PromoBanner.fromMap(Map<String, dynamic> map, String id) {
    // Fallback for old banners: use caption if title/description are missing
    final title = map['title'] ?? map['caption'] ?? '';
    final description = map['description'] ?? '';
    return PromoBanner(
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
