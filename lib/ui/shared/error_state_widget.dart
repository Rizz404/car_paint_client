import 'package:flutter/material.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });
  // TODO: DELETE THIS
  _onRetry() {
    LogService.i("ON RETRY, ERROR STATE WIDGET");
    onRetry();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
