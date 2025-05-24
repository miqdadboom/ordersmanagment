import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/app_notification.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final _collection = FirebaseFirestore.instance.collection('notifications');

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    final snapshot = await _collection.orderBy('timestamp', descending: true).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return AppNotification(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['body'] ?? '',
        senderName: 'System',
        timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
        isRead: data['isRead'] ?? false,
      );
    }).toList();
  }

  @override
  Future<AppNotification> fetchNotificationById(String id) async {
    final doc = await _collection.doc(id).get();
    final data = doc.data();
    if (data == null) throw Exception('Notification not found');

    return AppNotification(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['body'] ?? '',
      senderName: 'System',
      timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    try {
      await _collection.doc(id).update({'isRead': true});
      debugPrint('✅ Notification $id marked as read in Firestore');
    } catch (e) {
      debugPrint('⚠️ Failed to mark notification as read in Firestore: $e');
    }
  }
}
