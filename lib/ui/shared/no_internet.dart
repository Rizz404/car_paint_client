import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternet({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 48),
          const SizedBox(height: 8),
          const Text('No Internet Connection', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
