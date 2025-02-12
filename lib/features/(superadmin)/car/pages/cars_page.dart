import 'package:flutter/material.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const CarsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars Page'),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Cars Page"),
          ],
        ),
      ),
    );
  }
}
