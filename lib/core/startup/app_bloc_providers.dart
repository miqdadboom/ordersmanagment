import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../../features/notification/presentation/cubit/notification_cubit.dart';
import '../../../features/orders/data/datasources/order_data_source_impl.dart';
import '../../../features/notification/data/datasources/notification_remote_data_source_impl.dart';
import '../../../features/notification/data/datasources/notification_local_data_source_impl.dart';
import '../../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../../features/notification/domain/use_cases/get_notification_detail.dart';
import '../../../features/notification/domain/use_cases/get_notifications.dart';
import '../../../features/notification/domain/use_cases/mark_notification_as_read.dart';
import '../../features/orders/domain/repositories/orders_repository_impl.dart';

Widget buildBlocProviders({required Widget child}) {
  final orderDataSource = OrderDataSourceImpl();
  final orderRepository = OrderRepositoryImpl(dataSource: orderDataSource);

  final remoteDataSource = NotificationRemoteDataSourceImpl();
  final localDataSource = NotificationLocalDataSourceImpl(useMockData: false);
  final notificationRepository = NotificationRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => OrdersCubit(orderRepository),
      ),
      BlocProvider(
        create:
            (_) => NotificationCubit(
              getNotifications: GetNotifications(notificationRepository),
              getNotificationDetail: GetNotificationDetail(
                notificationRepository,
              ),
              markNotificationAsRead: MarkNotificationAsRead(
                notificationRepository,
              ),
            ),
      ),
    ],
    child: child,
  );
}
