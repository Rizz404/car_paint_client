import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Black background
      body: Center(
        child: Image.asset(
          'assets/images/logo/new_logo_512.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
