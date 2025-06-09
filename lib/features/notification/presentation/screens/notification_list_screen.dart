import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/core/constants/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/bottom_navigation_warehouse_manager.dart';
import '../../domain/entities/app_notification.dart';
import '../cubit/notification_cubit.dart';
import '../widgets/notification_item.dart';
import 'notification_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  String _senderFilter = '';
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final userId = user.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final role = doc.data()?['role'] ?? '';
    setState(() {
      _role = role;
    });
    await context.read<NotificationCubit>().loadNotifications(
      role: role,
      userId: userId,
    );
  }

  Future<void> _handleRefresh() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Notifications", showBackButton: false,),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading &&
              (state.notifications?.isEmpty ?? true)) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = state.notifications ?? [];
          final unreadCount = notifications.where((n) => !n.isRead).length;

          // Filter notifications by senderName
          final filteredNotifications =
              _senderFilter.isEmpty
                  ? notifications
                  : notifications
                      .where(
                        (n) => n.senderName.toLowerCase().contains(
                          _senderFilter.toLowerCase(),
                        ),
                      )
                      .toList();

          final todayNotifications =
              filteredNotifications
                  .where(
                    (n) => n.timestamp.isAfter(
                      DateTime.now().subtract(const Duration(days: 1)),
                    ),
                  )
                  .toList();
          final yesterdayNotifications =
              filteredNotifications
                  .where(
                    (n) =>
                        n.timestamp.isBefore(
                          DateTime.now().subtract(const Duration(days: 1)),
                        ) &&
                        n.timestamp.isAfter(
                          DateTime.now().subtract(const Duration(days: 2)),
                        ),
                  )
                  .toList();

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      top: 16,
                      right: 24,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${unreadCount > 0 ? '$unreadCount unread' : 'No unread'} notifications',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_role == 'warehouseEmployee')
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Filter by sender',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _senderFilter = value;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                if (todayNotifications.isNotEmpty)
                  _buildNotificationSection('Today', todayNotifications),
                if (yesterdayNotifications.isNotEmpty)
                  _buildNotificationSection(
                    'Yesterday',
                    yesterdayNotifications,
                  ),
                if (filteredNotifications.isEmpty &&
                    state is! NotificationLoading)
                  const SliverFillRemaining(
                    child: Center(child: Text('No notifications available')),
                  ),
                if (state is NotificationLoading &&
                    filteredNotifications.isNotEmpty)
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

  Widget _buildNotificationSection(
    String title,
    List<AppNotification> notifications,
  ) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        ...notifications.map(
          (notification) => NotificationItem(
            notification: notification,
            showDescription: false, // This hides the description
            onTap: () async {
              await context.read<NotificationCubit>().markNotificationRead(
                notification.id,
              );
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NotificationDetailScreen(
                        notificationId: notification.id,
                      ),
                ),
              );
              _loadNotifications();
            },
          ),
        ),
      ]),
    );
  }
}
