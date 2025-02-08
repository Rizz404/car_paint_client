import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';

class UpsertCarBrands extends StatefulWidget {
  final CarBrand? carBrand;
  const UpsertCarBrands({super.key, this.carBrand});
  static route() => MaterialPageRoute(builder: (_) => const UpsertCarBrands());

  @override
  State<UpsertCarBrands> createState() => _UpsertCarBrandsState();
}

class _UpsertCarBrandsState extends State<UpsertCarBrands> {
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.carBrand != null) {
      nameController.text = widget.carBrand!.name;
      countryController.text = widget.carBrand!.country ?? "";
    }
    LogService.i("Car Brand: ${widget.carBrand}");
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();

    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate() && _selectedImage != null) {
      LogService.i(
          "Nama Brand: ${nameController.text}, Country: ${countryController.text}, Image: $_selectedImage");
      context.read<CarBrandsCubit>().saveBrand(
            CarBrand(
              name: nameController.text,
              country: countryController.text,
            ),
            _selectedImage!,
          );
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
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
                    _selectedImage == null
                        ? ElevatedButton(
                            onPressed: pickImage,
                            child: const Text("Pick Image"),
                          )
                        : Image.file(_selectedImage!),
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
                    MainTextField(
                      controller: countryController,
                      hintText: "Enter country",
                      leadingIcon: const Icon(Icons.flag),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Country cannot be empty";
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
