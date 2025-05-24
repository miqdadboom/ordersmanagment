import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../domain/entities/app_notification.dart';
import '../cubit/notification_cubit.dart';
import '../widgets/notification_item.dart';
import 'notification_detail_screen.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await context.read<NotificationCubit>().loadNotifications();
  }

  Future<void> _handleRefresh() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading && (state.notifications?.isEmpty ?? true)) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = state.notifications ?? [];
          final unreadCount = notifications.where((n) => !n.isRead).length;

          final todayNotifications = notifications
              .where((n) => n.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 1))))
              .toList();
          final yesterdayNotifications = notifications
              .where((n) => n.timestamp.isBefore(DateTime.now().subtract(const Duration(days: 1))) &&
              n.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 2))))
              .toList();

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 16, bottom: 8),
                    child: Text(
                      '${unreadCount > 0 ? '$unreadCount unread' : 'No unread'} notifications',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                if (todayNotifications.isNotEmpty)
                  _buildNotificationSection('Today', todayNotifications),
                if (yesterdayNotifications.isNotEmpty)
                  _buildNotificationSection('Yesterday', yesterdayNotifications),
                if (notifications.isEmpty && state is! NotificationLoading)
                  const SliverFillRemaining(
                    child: Center(child: Text('No notifications available')),
                  ),
                if (state is NotificationLoading && notifications.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationWarehouseManager(),
    );
  }

  Widget _buildNotificationSection(String title, List<AppNotification> notifications) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        ...notifications.map((notification) => NotificationItem(
          notification: notification,
          showDescription: false, // This hides the description
          onTap: () async {
            await context.read<NotificationCubit>().markNotificationRead(notification.id);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationDetailScreen(notificationId: notification.id),
              ),
            );
            _loadNotifications();
          },
        )),
      ]),
    );
  }
}