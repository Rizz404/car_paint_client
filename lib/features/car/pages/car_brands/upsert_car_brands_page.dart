import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/widgets/image_car_action.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:paint_car/ui/utils/url_to_file.dart';
import 'package:paint_car/ui/validator/file_validator.dart';

class UpsertCarBrandsPage extends StatefulWidget {
  final CarBrand? carBrand;
  const UpsertCarBrandsPage({super.key, this.carBrand});
  static route({CarBrand? carBrand}) => MaterialPageRoute(
        builder: (context) => UpsertCarBrandsPage(carBrand: carBrand),
      );
  @override
  State<UpsertCarBrandsPage> createState() => _UpsertCarBrandsPageState();
}

class _UpsertCarBrandsPageState extends State<UpsertCarBrandsPage> {
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    setState(
      () {
        isUpdate = widget.carBrand != null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carBrand!.name;
        countryController.text = widget.carBrand!.country ?? "";
        _loadImage();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    countryController.dispose();

    super.dispose();
  }

  Future<void> _loadImage() async {
    if (widget.carBrand!.logo == null) return;
    try {
      final file = await urlToFile(widget.carBrand!.logo!);
      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      LogService.e("Error loading image: $e");
    }
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarBrandsCubit>().updateBrand(
            CarBrand(
              id: widget.carBrand!.id,
              name: nameController.text,
              country: countryController.text,
              createdAt: widget.carBrand!.createdAt,
              updatedAt: widget.carBrand!.updatedAt,
            ),
            _selectedImage,
          );
    } else {
      context.read<CarBrandsCubit>().saveBrand(
            CarBrand(
              name: nameController.text,
              country: countryController.text,
            ),
            _selectedImage!,
          );
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate() && _selectedImage != null) {
      _performAction();
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please select an image",
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        final fileSize = await File(pickedFile.path).length();
        fileValidatorSize(context, fileSize);
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } on PlatformException catch (e) {
      LogService.e("Error picking image: $e");
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Something went wrong picking image",
        type: SnackBarType.error,
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
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car brand ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car Brands" : "Create Car Brands",
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    MainText(
                      text: isUpdate ? "Update Car Brand" : "Create Car Brand",
                      extent: const Large(),
                    ),
                    ImageCarAction(
                      selectedImage: _selectedImage,
                      logoUrl: widget.carBrand?.logo,
                      onPickImage: _pickImage,
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
                      text: isUpdate ? "Update" : "Create",
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
