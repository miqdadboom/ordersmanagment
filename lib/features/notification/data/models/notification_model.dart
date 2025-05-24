import '../../domain/entities/app_notification.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String senderName;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.senderName,
    required this.timestamp,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      senderName: json['senderName'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'senderName': senderName,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      title: title,
      description: description,
      senderName: senderName,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  factory NotificationModel.fromEntity(AppNotification entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      senderName: entity.senderName,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? senderName,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      senderName: senderName ?? this.senderName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}