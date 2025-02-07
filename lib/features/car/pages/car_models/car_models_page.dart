import 'package:flutter/material.dart';
import 'package:paint_car/features/car/pages/car_models/upsert_car_models.dart';

class CarModelsPage extends StatelessWidget {
  const CarModelsPage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const CarModelsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars Models Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(UpsertCarModels.route());
        },
        child: const Icon(Icons.add),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Cars Models MEMEK Page"),
          ],
        ),
      ),
    );
  }
}
