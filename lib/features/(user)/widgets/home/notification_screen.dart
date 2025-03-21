import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/base_notification.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/cubit/notification_cubit.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.notifications.isEmpty) {
            return const Center(child: Text('No notifications yet'));
          }

          return ListView.builder(
            itemCount: state.notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  state.notifications[state.notifications.length - 1 - index];
              return _buildNotificationCard(context, notification);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<NotificationCubit>().clearNotifications(),
        child: const Icon(Icons.clear_all),
        tooltip: 'Clear all notifications',
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    BaseNotification notification,
  ) {
    IconData icon = _getNotificationIcon(notification.type);

    Color color = _getNotificationColor(notification.type);

    return Dismissible(
      key: Key(notification.hashCode.toString()),
      onDismissed: (_) {
        context.read<NotificationCubit>().removeNotification(notification);
      },
      background: Container(color: Colors.red),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(_getNotificationTitle(notification)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(notification.timestamp),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _handleNotificationTap(context, notification);
          },
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'testing':
        return Icons.info_outline;
      case 'ORDER_CREATED':
        return Icons.add_circle_outline;
      case 'ORDER_PROCESSING':
        return Icons.loop;
      case 'ORDER_COMPLETED':
        return Icons.check_circle_outline;
      case 'ORDER_CANCELLED':
        return Icons.cancel_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'testing':
        return Colors.blue;
      case 'ORDER_CREATED':
        return Colors.green;
      case 'ORDER_PROCESSING':
        return Colors.orange;
      case 'ORDER_COMPLETED':
        return Colors.green;
      case 'ORDER_CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getNotificationTitle(BaseNotification notification) {
    switch (notification.type) {
      case 'testing':
        return 'Test Notification';
      case 'ORDER_CREATED':
        return 'New Order';
      case 'ORDER_PROCESSING':
        return 'Order in Progress';
      case 'ORDER_COMPLETED':
        return 'Order Completed';
      case 'ORDER_CANCELLED':
        return 'Order Cancelled';
      default:
        return notification.type
            .split('_')
            .map(
              (word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
            )
            .join(' ');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateToCheck == today) {
      return 'Today, ${DateFormat.jm().format(dateTime)}';
    } else if (dateToCheck == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat.jm().format(dateTime)}';
    } else if (now.difference(dateTime).inDays < 7) {
      return '${DateFormat.E().format(dateTime)}, ${DateFormat.jm().format(dateTime)}';
    } else {
      return DateFormat('MMM d, y - h:mm a').format(dateTime);
    }
  }

  void _handleNotificationTap(
    BuildContext context,
    BaseNotification notification,
  ) {
    try {
      if (notification.type.startsWith('ORDER_') && notification.data != null) {
        if (notification.data is Map<String, dynamic> &&
            (notification.data as Map<String, dynamic>).containsKey('id')) {
          return;
        }
      }

      if (notification.type == 'testing') {
        _showDetailDialog(context, notification);
        return;
      }

      _showDetailDialog(context, notification);
    } catch (e) {
      LogService.e('Error handling notification tap: $e');

      _showErrorDialog(context, 'Could not process this notification');
    }
  }

  void _showDetailDialog(BuildContext context, BaseNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getNotificationTitle(notification)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Message: ${notification.message}'),
              const SizedBox(height: 8),
              Text(
                'Time: ${DateFormat('MMM d, y - h:mm a').format(notification.timestamp)}',
              ),
              const SizedBox(height: 8),
              Text('Type: ${notification.type}'),
              if (notification.data != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Additional Data:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDataDetails(notification.data),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataDetails(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('${entry.key}: ${_formatDataValue(entry.value)}'),
          );
        }).toList(),
      );
    } else if (data is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child:
                Text('Item ${entry.key + 1}: ${_formatDataValue(entry.value)}'),
          );
        }).toList(),
      );
    } else {
      return Text(data.toString());
    }
  }

  String _formatDataValue(dynamic value) {
    if (value is Map || value is List) {
      return '...';
    } else {
      return value.toString();
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
