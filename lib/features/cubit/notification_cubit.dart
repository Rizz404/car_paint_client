// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:paint_car/data/local/token_sp.dart';
// import 'package:paint_car/data/local/user_sp.dart';
// import 'package:paint_car/data/models/base_notification.dart';
// import 'package:paint_car/data/models/orders.dart';
// import 'package:paint_car/data/models/transactions.dart';
// import 'package:paint_car/dependencies/services/log_service.dart';
// import 'package:paint_car/dependencies/services/socket.dart';

// class NotificationState {
//   final List<BaseNotification> notifications;
//   final bool isLoading;
//   final String? error;

//   NotificationState({
//     this.notifications = const [],
//     this.isLoading = false,
//     this.error,
//   });

//   NotificationState copyWith({
//     List<BaseNotification>? notifications,
//     bool? isLoading,
//     String? error,
//   }) {
//     return NotificationState(
//       notifications: notifications ?? this.notifications,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// class NotificationCubit extends Cubit<NotificationState> {
//   final SocketService socketService;
//   StreamSubscription? _generalSubscription;
//   StreamSubscription? _orderSubscription;
//   StreamSubscription? _transactionSubscription;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   UserLocal userSp;
//   TokenLocal tokenSp;

//   final Map<String, Function(BaseNotification)> _notificationHandlers = {};

//   NotificationCubit({
//     required this.socketService,
//     required this.flutterLocalNotificationsPlugin,
//     required this.userSp,
//     required this.tokenSp,
//   }) : super(NotificationState()) {
//     _initializeNotifications();
//     _initializeSocketService();
//     _registerDefaultHandlers();
//   }

//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//   }

//   void _initializeSocketService() {
//     final user = userSp.getUser();
//     final token = tokenSp.getToken();

//     if (user != null && token != null) {
//       socketService.connect(token);

//       _orderSubscription =
//           socketService.orderNotifications.listen((notification) {
//         _handleTypedNotification<Orders>(notification, 'order');
//       });

//       _transactionSubscription =
//           socketService.transactionNotifications.listen((notification) {
//         _handleTypedNotification<Transactions>(notification, 'transaction');
//       });
//     }
//   }

//   // * Reinit
//   void reinitialize() {
//     resetState();

//     final user = userSp.getUser();
//     final token = tokenSp.getToken();

//     if (user != null && token != null) {
//       socketService.connect(token);

//       _orderSubscription?.cancel();
//       _orderSubscription =
//           socketService.orderNotifications.listen((notification) {
//         _handleTypedNotification<Orders>(notification, 'order');
//       });

//       _transactionSubscription?.cancel();
//       _transactionSubscription =
//           socketService.transactionNotifications.listen((notification) {
//         _handleTypedNotification<Transactions>(notification, 'transaction');
//       });
//     }
//   }

//   void _registerDefaultHandlers() {
//     registerNotificationHandler('order', (notification) {
//       _showNotification(notification, "Order Status");
//     });

//     registerNotificationHandler('order:admin', (notification) {
//       _showNotification(notification, "Order Admin Alert");
//     });

//     registerNotificationHandler('work_status', (notification) {
//       _showNotification(notification, "Work Status");
//     });

//     registerNotificationHandler('work_status:admin', (notification) {
//       _showNotification(notification, "Work Status Admin Alert");
//     });

//     registerNotificationHandler('transaction', (notification) {
//       _showNotification(notification, "Payment Status");
//     });

//     registerNotificationHandler('transaction:admin', (notification) {
//       _showNotification(notification, "Payment Admin Alert");
//     });
//   }

//   void registerNotificationHandler(
//     String type,
//     Function(BaseNotification) handler,
//   ) {
//     _notificationHandlers[type] = handler;
//   }

//   void _handleNotification(BaseNotification notification) {
//     final updatedNotifications = [...state.notifications, notification];
//     emit(state.copyWith(notifications: updatedNotifications));

//     if (_notificationHandlers.containsKey(notification.type)) {
//       _notificationHandlers[notification.type]!(notification);
//     } else {
//       _showNotification(notification);
//     }
//   }

//   void _handleTypedNotification<T>(
//     BaseNotification<T> notification,
//     String category,
//   ) {
//     final updatedNotifications = [
//       ...state.notifications,
//       notification as BaseNotification,
//     ];
//     emit(state.copyWith(notifications: updatedNotifications));

//     if (_notificationHandlers.containsKey(notification.type)) {
//       _notificationHandlers[notification.type]!(notification);
//     } else {
//       _showNotification(notification, category);
//     }

//     LogService.i(
//       '[Notification] Received ${T.toString()} notification: ${notification.type}',
//     );
//   }

//   Future<void> _showNotification(
//     BaseNotification notification, [
//     String? title,
//   ]) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'notification_channel',
//       'General Notifications',
//       channelDescription: 'Notifications from the application',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iOSPlatformChannelSpecifics =
//         DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       title ?? notification.type,
//       notification.message,
//       platformChannelSpecifics,
//       payload: notification.type,
//     );
//   }

//   Future<void> addNotification(BaseNotification notification) async {
//     _handleNotification(notification);
//   }

//   void reconnect() {
//     final token = tokenSp.getToken();
//     if (token != null) {
//       socketService.connect(token);
//     }
//   }

//   void clearNotifications() {
//     emit(state.copyWith(notifications: []));
//   }

//   void resetState() {
//     emit(NotificationState());
//   }

//   void removeNotification(BaseNotification notification) {
//     final updatedNotifications = state.notifications
//         .where((n) => n.hashCode != notification.hashCode)
//         .toList();
//     emit(state.copyWith(notifications: updatedNotifications));
//   }

//   @override
//   Future<void> close() {
//     _generalSubscription?.cancel();
//     _orderSubscription?.cancel();
//     _transactionSubscription?.cancel();
//     socketService.dispose();
//     return super.close();
//   }
// }
