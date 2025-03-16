import 'dart:async';
import 'package:paint_car/data/models/base_notification.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final IO.Socket socket;

  // Use multiple controllers for different notification types
  final _stringNotificationController =
      StreamController<BaseNotification<String>>.broadcast();
  final _orderNotificationController =
      StreamController<BaseNotification<Orders>>.broadcast();
  final _transactionNotificationController =
      StreamController<BaseNotification<Transactions>>.broadcast();

  // Add debug flags and controllers
  final _rawMessageController = StreamController<dynamic>.broadcast();
  bool enableDebugLogs = true;

  SocketService({required this.socket, this.enableDebugLogs = true}) {
    _setupEventHandlers();
  }

  // Expose streams for different notification types
  Stream<BaseNotification<String>> get stringNotifications =>
      _stringNotificationController.stream;
  Stream<BaseNotification<Orders>> get orderNotifications =>
      _orderNotificationController.stream;
  Stream<BaseNotification<Transactions>> get transactionNotifications =>
      _transactionNotificationController.stream;

  Stream<dynamic> get rawMessages => _rawMessageController.stream;

  void connect(String token) {
    if (socket.connected) {
      _debugLog('Socket was already connected, disconnecting first');
      socket.disconnect();
    }

    // Set auth token in socket connection
    socket.auth = {'token': token};

    socket.connect();
  }

  // Helper to safely stringify objects for debugging
  String _safeStringify(dynamic obj) {
    try {
      return obj.toString();
    } catch (e) {
      return 'Unable to stringify: $e';
    }
  }

  void disconnect() {
    _debugLog('Manual disconnect called');
    socket.disconnect();
  }

  void resetAuth() {
    // Hapus token dari konfigurasi socket
    socket.auth = null;
    // Hentikan reconnect otomatis
    socket.io.options!['autoConnect'] = false;
    _debugLog('Socket auth reset');
  }

  void joinWorkshop(String workshopId) {
    if (socket.connected) {
      socket.emit('join:room', 'workshop:$workshopId');
      _debugLog('Joining workshop room: workshop:$workshopId');
    } else {
      _debugLog('Cannot join workshop: Socket not connected', isError: true);
    }
  }

  void joinRoom(String roomName) {
    if (socket.connected) {
      socket.emit('join:room', roomName);
      _debugLog('Joining custom room: $roomName');
    } else {
      _debugLog('Cannot join room: Socket not connected', isError: true);
    }
  }

  void _setupEventHandlers() {
    socket.onConnect((_) {
      _debugLog('Socket Connected - ID: ${socket.id}');
    });

    socket.onConnectError((error) {
      _debugLog('Socket Connect Error: $error', isError: true);
    });

    socket.onError((error) {
      _debugLog('Socket Error: $error', isError: true);
    });

    socket.onDisconnect((_) {
      _debugLog('Socket Disconnected');
    });

    // Listen to all events for debugging
    socket.onAny((event, data) {
      _debugLog('Event received: $event with data: ${_safeStringify(data)}');
      _rawMessageController.add({'event': event, 'data': data});
    });

    // Standard notification event
    socket.on('notification', (data) {
      _debugLog('Notification event received: ${_safeStringify(data)}');
      _handleNotification(data);
    });

    // Listen for order updates
    socket.on('order:update', (data) {
      _debugLog('Order update received: ${_safeStringify(data)}');
      _handleOrderNotification(data);
    });

    // Listen for work status updates
    socket.on('work_status:update', (data) {
      _debugLog('Work status update received: ${_safeStringify(data)}');
      _handleOrderNotification(data);
    });

    // Listen for transaction updates
    socket.on('transaction:update', (data) {
      _debugLog('Transaction update received: ${_safeStringify(data)}');
      _handleTransactionNotification(data);
    });

    socket.on('error', (error) {
      _debugLog('Socket server error: $error', isError: true);
    });
  }

  void _handleNotification(dynamic data) {
    try {
      _debugLog('Processing notification data: ${_safeStringify(data)}');

      if (data is Map<String, dynamic>) {
        // Check if data matches BaseNotification structure
        if (data.containsKey('type') &&
            data.containsKey('message') &&
            data.containsKey('timestamp')) {
          _debugLog('Valid notification format detected');

          // Create BaseNotification object with String data
          final notification = BaseNotification<String>.fromMap(data);

          // Add to the stream
          _stringNotificationController.add(notification);

          _debugLog(
              'Notification processed: [${notification.type}] ${notification.message}');
        } else {
          _debugLog(
              'Notification missing required fields: ${_safeStringify(data)}',
              isError: true);
        }
      } else {
        _debugLog('Invalid notification format: ${data.runtimeType}',
            isError: true);
      }
    } catch (e, stackTrace) {
      _debugLog('Error handling notification: $e\nStack: $stackTrace',
          isError: true);
    }
  }

  void _handleOrderNotification(dynamic data) {
    try {
      if (data is Map<String, dynamic> &&
          data.containsKey('type') &&
          data.containsKey('message') &&
          data.containsKey('timestamp') &&
          data.containsKey('data')) {
        // Create a function that converts Map<String, dynamic> to Orders
        // This bridges the gap between your typedef and Orders.fromJson
        FromJsonFunction<Orders> mapToOrders = (Map<String, dynamic> json) {
          return Orders.fromMap(json);
        };

        // Parse the data as an Order using the adapter function
        final notification = BaseNotification<Orders>.fromMap(
          data,
          fromJson: mapToOrders,
        );

        _orderNotificationController.add(notification);

        _debugLog(
            'Order notification processed: [${notification.type}] ${notification.message}');
      } else {
        _debugLog('Invalid order notification format', isError: true);
      }
    } catch (e, stackTrace) {
      _debugLog('Error handling order notification: $e\nStack: $stackTrace',
          isError: true);
    }
  }

  void _handleTransactionNotification(dynamic data) {
    try {
      if (data is Map<String, dynamic> &&
          data.containsKey('type') &&
          data.containsKey('message') &&
          data.containsKey('timestamp') &&
          data.containsKey('data')) {
        // Create a function that converts Map<String, dynamic> to Transactions
        FromJsonFunction<Transactions> mapToTransactions =
            (Map<String, dynamic> json) {
          return Transactions.fromMap(json);
        };

        // Parse the data as a Transaction
        final notification = BaseNotification<Transactions>.fromMap(
          data,
          fromJson: mapToTransactions,
        );

        _transactionNotificationController.add(notification);

        _debugLog(
            'Transaction notification processed: [${notification.type}] ${notification.message}');
      } else {
        _debugLog('Invalid transaction notification format', isError: true);
      }
    } catch (e, stackTrace) {
      _debugLog(
          'Error handling transaction notification: $e\nStack: $stackTrace',
          isError: true);
    }
  }

  // Debug logging helper
  void _debugLog(String message, {bool isError = false}) {
    if (enableDebugLogs) {
      if (isError) {
        LogService.e('[SocketDebug] $message');
      } else {
        LogService.i('[SocketDebug] $message');
      }
    }
  }

  // Method to manually emit events for testing
  void emitTest(String event, dynamic data) {
    if (socket.connected) {
      socket.emit(event, data);
      _debugLog(
          'Test event emitted: $event with data: ${_safeStringify(data)}');
    } else {
      _debugLog('Cannot emit test: Socket not connected', isError: true);
    }
  }

  // Method to check socket connection status
  bool get isConnected => socket.connected;

  // Get current socket ID
  String? get socketId => socket.id;

  void dispose() {
    socket.disconnect();
    _stringNotificationController.close();
    _orderNotificationController.close();
    _transactionNotificationController.close();
    _rawMessageController.close();
    _debugLog('Socket service disposed');
  }
}
