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
import 'package:paint_car/ui/utils/url_to_file.dart';
import 'package:paint_car/ui/validator/file_validator.dart';

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
  static const limit = 200;
  late final CancelToken _cancelToken;
  var selectedCarModelYearColorId;
  final carModelYearColorIdController = TextEditingController();
  final licensePlateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<File> _selectedImages = [];
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    getCarModelYearColor();

    setState(
      () {
        isUpdate = widget.userCar != null;

        selectedCarModelYearColorId = widget.userCar?.carModelYearColorId;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        licensePlateController.text = widget.userCar!.licensePlate;
        _loadImage();
      }
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _selectedImages.clear();
    carModelYearColorIdController.dispose();

    licensePlateController.dispose();

    super.dispose();
  }

  Future<void> _loadImage() async {
    if (widget.userCar?.carImages == null ||
        widget.userCar!.carImages!.isEmpty) {
      return;
    }

    try {
      final futures = widget.userCar!.carImages!
          .where((url) => url != null)
          .map((url) => urlToFile(url!));

      final files = await Future.wait(futures);

      setState(() {
        _selectedImages = files;
      });
    } catch (e) {
      LogService.e("Error loading images: $e");
    }
  }

  void _performAction() {
    if (isUpdate) {
      context.read<UserCarCubit>().updateUserCar(
            UserCar(
              id: widget.userCar!.id,
              licensePlate: licensePlateController.text,
              createdAt: widget.userCar!.createdAt,
              updatedAt: widget.userCar!.updatedAt,
              carModelYearColorId: selectedCarModelYearColorId,
            ),
            _selectedImages,
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
      if (_selectedImages.isEmpty) {
        SnackBarUtil.showSnackBar(
          context: context,
          message: "Harap pilih minimal 1 gambar",
          type: SnackBarType.error,
        );
        return;
      }
      _performAction();
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFiles.isNotEmpty) {
        // Validasi maksimal 5 gambar
        if (_selectedImages.length + pickedFiles.length > 5) {
          SnackBarUtil.showSnackBar(
            context: context,
            message: "Maksimal 5 gambar yang diizinkan",
            type: SnackBarType.error,
          );
          return;
        }

        // Validasi ukuran file
        final validFiles = <File>[];
        for (final pickedFile in pickedFiles) {
          final file = File(pickedFile.path);
          final fileSize = await file.length();
          fileValidatorSize(context, fileSize);
          validFiles.add(file);
        }

        setState(() {
          _selectedImages.addAll(validFiles);
        });
      }
    } on PlatformException {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Gagal memilih gambar",
        type: SnackBarType.error,
      );
    }
  }

  Future<void> getCarModelYearColor() async {
    await context.read<CarModelYearColorCubit>().refresh(limit, _cancelToken);
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
              message:
                  "Car userCar ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car UserCars" : "Create Car UserCars",
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
                      text: isUpdate
                          ? "Update Car UserCar"
                          : "Create Car UserCar",
                      extent: const Large(),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index < _selectedImages.length) {
                          return Stack(
                            children: [
                              Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImages.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        } else {
                          return GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.add_a_photo, size: 40),
                            ),
                          );
                        }
                      },
                    ),
                    MainTextField(
                      controller: licensePlateController,
                      hintText: "Enter License Plate",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "License Plate cannot be empty";
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
