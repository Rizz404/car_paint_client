import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const UsersPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Page'),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Users Page"),
          ],
        ),
      ),
    );
  }
}
