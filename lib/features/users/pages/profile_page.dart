import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const ProfilePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Profile Page"),
          ],
        ),
      ),
    );
  }
}
