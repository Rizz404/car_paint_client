import 'dart:async';

import 'package:paint_car/data/models/order_notification.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final IO.Socket socket;
  final _notificationController =
      StreamController<OrderNotification>.broadcast();
  String? _currentUserId;

  SocketService({required this.socket}) {
    _setupEventHandlers();
  }

  Stream<OrderNotification> get notifications => _notificationController.stream;

  void connect(String userId) {
    _currentUserId = userId;
    if (!socket.connected) {
      socket.connect();
    }
    socket.emit('join:user', userId);
    LogService.i('Socket Connecting with user id: $userId');
  }

  void _setupEventHandlers() {
    socket.onConnect((_) {
      LogService.i('Socket Connected');
      if (_currentUserId != null) {
        LogService.i('Socket Connected with user id: $_currentUserId');
        socket.emit('join:user', _currentUserId!);
      }
    });

    socket.onDisconnect((_) => LogService.i('Socket Disconnected'));
    socket.on('notification', (data) => _handleNotification(data));
  }

  void _handleNotification(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        final notification = OrderNotification.fromMap(data);
        _notificationController.add(notification);
      } else {
        LogService.e('Invalid notification format: $data');
      }
    } catch (e) {
      LogService.e('Error handling notification: $e');
    }
  }

  void dispose() {
    socket.disconnect();
    _notificationController.close();
  }
}
