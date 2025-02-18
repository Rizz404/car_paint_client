import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UpsertUserCarPage extends StatefulWidget {
  final UserCar? userCar;
  const UpsertUserCarPage({super.key, this.userCar});

  static route({UserCar? userCar}) => MaterialPageRoute(
        builder: (context) => UpsertUserCarPage(userCar: userCar),
      );

  @override
  State<UpsertUserCarPage> createState() => _UpsertUserCarPageState();
}

class _UpsertUserCarPageState extends State<UpsertUserCarPage> {
  late final CancelToken _cancelToken;
  final formKey = GlobalKey<FormState>();

  // Controllers for your form fields
  final licensePlateController = TextEditingController();
  var selectedCarModelYearColorId;
  final carModelYearColorIdController = TextEditingController();

  // Add other controllers based on your UserCar model

  final List<File> _selectedImages = [];
  List<String> _existingImages = [];
  final List<String> _imagesToDelete = [];
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    getCarModelYearColor();

    setState(() {
      isUpdate = widget.userCar != null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        licensePlateController.text = widget.userCar!.licensePlate;
        selectedCarModelYearColorId = widget.userCar!.carModelYearColorId;
        _loadExistingImages();
      }
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    for (var image in _selectedImages) {
      image.delete();
    }
    _selectedImages.clear();

    licensePlateController.dispose();
    // Dispose other controllers

    super.dispose();
  }

  Future<void> _loadExistingImages() async {
    if (widget.userCar?.carImages == null) return;
    try {
      setState(() {
        _existingImages = List<String>.from(widget.userCar!.carImages!);
      });
    } catch (e) {
      LogService.e("Error loading existing images: $e");
    }
  }

  void _performAction() {
    if (isUpdate) {
      context.read<UserCarCubit>().updateUserCar(
            UserCar(
              createdAt: widget.userCar!.createdAt,
              updatedAt: widget.userCar!.updatedAt,
              id: widget.userCar!.id,
              licensePlate: licensePlateController.text,
              // Add other fields from your UserCar model
              carImages: _existingImages,
              carModelYearColorId: selectedCarModelYearColorId,
            ),
            _selectedImages,
            _imagesToDelete,
            _cancelToken,
          );
    } else {
      context.read<UserCarCubit>().saveUserCar(
            UserCar(
              userId: context.currentUser!.id,
              licensePlate: licensePlateController.text,
              carModelYearColorId: selectedCarModelYearColorId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            _selectedImages,
            _cancelToken,
          );
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (!isUpdate && _selectedImages.isEmpty) {
        SnackBarUtil.showSnackBar(
          context: context,
          message: "Please select at least one image",
          type: SnackBarType.error,
        );
        return;
      }
      _performAction();
    }
  }

  Future<void> _pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
      );

      for (var pickedFile in pickedFiles) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
        // if (fileValidatorSize(context, fileSize, showMessage: false)) {
        // } else {
        //   SnackBarUtil.showSnackBar(
        //     context: context,
        //     message: "Some images exceeded size limit",
        //     type: SnackBarType.warning,
        //   );
        // }
      }
    } on PlatformException catch (e) {
      LogService.e("Error picking images: $e");
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Something went wrong picking images",
        type: SnackBarType.error,
      );
    }
  }

  void _removeExistingImage(String imageUrl) {
    setState(() {
      _existingImages.remove(imageUrl);
      _imagesToDelete.add(imageUrl);
    });
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages[index].delete();
      _selectedImages.removeAt(index);
    });
  }

  Future<void> getCarModelYearColor() async {
    await context.read<CarModelYearColorCubit>().refresh(100, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCarCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Car ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car" : "Create Car",
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
                      text: isUpdate ? "Update Car" : "Create Car",
                      extent: const Large(),
                    ),
                    MultiImageCarAction(
                      selectedImages: _selectedImages,
                      existingImages: _existingImages,
                      onPickImages: _pickImages,
                      onRemoveExisting: _removeExistingImage,
                      onRemoveSelected: _removeSelectedImage,
                    ),
                    MainTextField(
                      controller: licensePlateController,
                      hintText: "Enter car licensePlate",
                      leadingIcon: const Icon(Icons.drive_eta),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Car licensePlate cannot be empty";
                        }
                        return null;
                      },
                    ),
                    StateHandler<CarModelYearColorCubit,
                        PaginationState<CarModelYearColor>>(
                      onRetry: () => getCarModelYearColor(),
                      onSuccess: (context, data, _) {
                        final modelYears = data.data;
                        return DropdownMenu(
                          width: double.infinity,
                          controller: carModelYearColorIdController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedCarModelYearColorId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedCarModelYearColorId = value;
                            });
                          },
                          label: const MainText(
                            text: "Select Car Model Year Color",
                          ),
                          dropdownMenuEntries: modelYears.map((modelYear) {
                            return DropdownMenuEntry(
                              labelWidget: MainText(
                                text: modelYear.color!.name,
                              ),
                              value: modelYear.id,
                              label: modelYear.color!.name,
                            );
                          }).toList(),
                        );
                      },
                    ),

                    // Add other form fields based on your UserCar model
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

// MultiImageCarAction widget
class MultiImageCarAction extends StatelessWidget {
  final List<File> selectedImages;
  final List<String> existingImages;
  final VoidCallback onPickImages;
  final Function(String) onRemoveExisting;
  final Function(int) onRemoveSelected;

  const MultiImageCarAction({
    super.key,
    required this.selectedImages,
    required this.existingImages,
    required this.onPickImages,
    required this.onRemoveExisting,
    required this.onRemoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onPickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Images'),
        ),
        const SizedBox(height: 16),
        if (existingImages.isNotEmpty) ...[
          const Text('Existing Images'),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: existingImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(
                        existingImages[index],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () =>
                            onRemoveExisting(existingImages[index]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        if (selectedImages.isNotEmpty) ...[
          const Text('New Images'),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.file(
                        selectedImages[index],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => onRemoveSelected(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
