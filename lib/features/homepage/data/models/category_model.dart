import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name,
    required String imageUrl,
    List<String> subtypes = const [],
  }) : super(id: id, name: name, imageUrl: imageUrl, subtypes: subtypes);

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      subtypes:
          (map['subtypes'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'imageUrl': imageUrl, 'subtypes': subtypes};
  }
}
