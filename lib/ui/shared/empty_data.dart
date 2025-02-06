import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String message;

  const EmptyData({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Image(image: const AssetImage('assets/images/empty_data.png')),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
