import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:paint_car/data/local/user_sp.dart';
import 'package:paint_car/data/models/order_notification.dart';
import 'package:paint_car/dependencies/services/socket.dart';

class NotificationCubit extends Cubit<List<OrderNotification>> {
  final SocketService socketService;
  StreamSubscription? _subscription;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  UserLocal userSp;

  NotificationCubit({
    required this.socketService,
    required this.flutterLocalNotificationsPlugin,
    required this.userSp,
  }) : super([]) {
    _initializeNotifications();
    _initializeSocketService();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void _initializeSocketService() {
    _subscription = socketService.notifications.listen(_handleNotification);
  }

  void _handleNotification(OrderNotification notification) {
    final user = userSp.getUser();
    if (user == null) return;
    if (notification.userId == user.id) {
      emit([...state, notification]);
      _showNotification(notification);
    }
  }

  Future<void> _showNotification(OrderNotification notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Notifications for order status updates',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      'Order Update',
      notification.message,
      platformChannelSpecifics,
    );
  }

  Future<void> addNotification(OrderNotification notification) async {
    _handleNotification(notification);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    socketService.dispose();
    return super.close();
  }
}
