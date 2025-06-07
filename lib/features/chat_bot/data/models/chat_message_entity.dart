class ChatMessageEntity {
  final String id;
  final String text;
  final DateTime createdAt;
  final Author author;
  final bool isImage;

  ChatMessageEntity({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.author,
    this.isImage = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'author': author.toMap(),
      'isImage': isImage,
    };
  }

  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) {
    return ChatMessageEntity(
      id: map['id'],
      text: map['text'],
      createdAt: DateTime.parse(map['createdAt']),
      author: Author.fromMap(map['author']),
      isImage: map['isImage'] ?? false,
    );
  }
}

class Author {
  final String id;
  final String name;

  Author({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'],
      name: map['name'],
    );
  }
}
