import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isRetrying;

  const NoInternet({super.key, required this.onRetry, this.isRetrying = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 48),
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
