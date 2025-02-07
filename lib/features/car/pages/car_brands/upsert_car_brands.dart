import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';

class UpsertCarBrands extends StatefulWidget {
  const UpsertCarBrands({super.key});
  static route() => MaterialPageRoute(builder: (_) => const UpsertCarBrands());

  @override
  State<UpsertCarBrands> createState() => _UpsertCarBrandsState();
}

class _UpsertCarBrandsState extends State<UpsertCarBrands> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      // call cubit to save car brand
      LogService.i("Nama Brand: ${nameController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarBrandsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Car Brand saved successfully!")),
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const MainText(text: "Create Car Brand"),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    const MainText(
                      text: "Create Car Brands",
                      extent: Large(),
                    ),
                    MainTextField(
                      controller: nameController,
                      hintText: "Enter brand name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Brand name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainElevatedButton(
                      onPressed: submitForm,
                      text: "Save Brand",
                      isLoading: state is BaseLoadingState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
