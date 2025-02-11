import 'package:flutter/material.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isRetrying;

  const ErrorStateWidget({
    required this.message,
    required this.onRetry,
    this.isRetrying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          const Icon(Icons.error, size: 48, color: Colors.red),
          MainText(
            text: message,
            textAlign: TextAlign.center,
          ),
          if (isRetrying)
            const CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }
}
