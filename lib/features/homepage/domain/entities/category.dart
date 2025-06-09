class Category {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> subtypes;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subtypes = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      subtypes:
          (json['subtypes'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'subtypes': subtypes,
  };
}
