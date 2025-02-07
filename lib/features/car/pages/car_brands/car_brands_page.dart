import 'package:flutter/material.dart';
import 'package:paint_car/features/car/pages/car_brands/upsert_car_brands.dart';

class CarBrandsPage extends StatelessWidget {
  const CarBrandsPage({super.key});
  static route() => MaterialPageRoute(builder: (_) => const CarBrandsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cars Brands Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(UpsertCarBrands.route());
        },
        child: const Icon(Icons.add),
      ),
      body: const SingleChildScrollView(
        child: const Column(
          children: [
            const Text("Cars Brands MEMEK Page"),
          ],
        ),
      ),
    );
  }
}
