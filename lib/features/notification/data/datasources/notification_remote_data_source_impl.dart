import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/app_notification.dart';
import 'notification_remote_data_source.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final _collection = FirebaseFirestore.instance.collection('notifications');

  @override
  Future<List<AppNotification>> fetchNotifications({
    required String role,
    required String userId,
  }) async {
    Query query = _collection.orderBy('timestamp', descending: true);
    List<AppNotification> notifications;
    if (role == 'salesRepresentative') {
      query = query.where('sendTo', isEqualTo: userId);
      final snapshot = await query.get();
      notifications =
          snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return AppNotification(
              id: doc.id,
              title: data['title'] ?? '',
              description: data['body'] ?? '',
              senderName: data['senderName'] ?? 'System',
              timestamp: _parseTimestamp(data['timestamp']),
              isRead: data['isRead'] ?? false,
            );
          }).toList();
    } else {
      // admin and warehouseEmployee: fetch all, filter in Dart for warehouseEmployee
      final snapshot = await query.get();
      var docs = snapshot.docs;
      if (role == 'warehouseEmployee') {
        docs =
            docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['createdBy'] != userId;
            }).toList();
      }
      notifications =
          docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return AppNotification(
              id: doc.id,
              title: data['title'] ?? '',
              description: data['body'] ?? '',
              senderName: data['senderName'] ?? 'System',
              timestamp: _parseTimestamp(data['timestamp']),
              isRead: data['isRead'] ?? false,
            );
          }).toList();
    }
    return notifications;
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
      senderName: data['senderName'] ?? 'System',
      timestamp: _parseTimestamp(data['timestamp']),
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

  DateTime _parseTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }
}
