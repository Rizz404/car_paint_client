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
import 'package:paint_car/features/(superadmin)/car/widgets/image_car_action.dart';
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
  File? _selectedImage;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();

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
    _selectedImage?.delete();
    _selectedImage = null;

    licensePlateController.dispose();

    super.dispose();
  }

  Future<void> _loadImage() async {
    if (widget.userCar!.carImages?.first == null) return;
    try {
      final file = await urlToFile(widget.userCar!.carImages!.first!);
      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      // TODO: DELETE LATERR
      LogService.e("Error loading image: $e");
    }
  }

  void _performAction() {
    if (isUpdate) {
      context.read<UserCarCubit>().updateUserCar(
            UserCar(
              id: widget.userCar!.id,
              userId: widget.userCar!.userId,
              licensePlate: licensePlateController.text,
              createdAt: widget.userCar!.createdAt,
              updatedAt: widget.userCar!.updatedAt,
              carModelYearColorId: selectedCarModelYearColorId,
            ),
            // TODO: REPLACE
            List.from([_selectedImage!]),
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
            // TODO: REPLACE
            List.from([_selectedImage!]),
            _cancelToken,
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
      // TODO: DELETE LATERR

      LogService.e("Error picking image: $e");
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Something went wrong picking image",
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
                    ImageCarAction(
                      selectedImage: _selectedImage,
                      logoUrl: widget.userCar?.carImages?.first,
                      onPickImage: _pickImage,
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
