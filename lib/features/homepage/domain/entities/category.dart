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
}
