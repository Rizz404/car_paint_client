import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/home/cubit/home_cubit.dart';
import 'package:paint_car/ui/shared/empty_data.dart';
import 'package:paint_car/ui/shared/error_state_widget.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/no_internet.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: StateHandler(
            onRetry: context.read<HomeCubit>().getBrands,
            onSuccess: (context, state) {
              final brands = (state as BaseSuccessState).data as List<CarBrand>;
              switch (brands.isEmpty) {
                case true:
                  return EmptyData(message: "Brands is empty");
                case false:
                  return ListView.builder(
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        final brand = brands[index];
                        return ListTile(
                          title: Text(brand.name),
                        );
                      });
              }
            }));
  }
}
