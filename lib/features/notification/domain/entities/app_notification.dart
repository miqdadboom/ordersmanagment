class AppNotification {
  final String id;
  final String title;
  final String description;
  final String senderName;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.senderName,
    required this.timestamp,
    required this.isRead,
  });

  // Add this copyWith method
  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    String? senderName,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  // Optional: Add equality comparison and toString
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppNotification &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              title == other.title &&
              description == other.description &&
              senderName == other.senderName &&
              timestamp == other.timestamp &&
              isRead == other.isRead;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      senderName.hashCode ^
      timestamp.hashCode ^
      isRead.hashCode;

  @override
  String toString() {
    return 'AppNotification{id: $id, title: $title, isRead: $isRead}';
  }
}