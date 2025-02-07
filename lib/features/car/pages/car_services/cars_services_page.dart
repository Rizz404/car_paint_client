import 'package:flutter/material.dart';

class CarsServicesPage extends StatelessWidget {
  const CarsServicesPage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const CarsServicesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars Services Page'),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Cars Services Page"),
          ],
        ),
      ),
    );
  }
}
