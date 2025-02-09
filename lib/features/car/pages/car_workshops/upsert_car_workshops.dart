import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UpsertCarWorkshopsPage extends StatefulWidget {
  final CarWorkshop? carWorkshop;
  const UpsertCarWorkshopsPage({super.key, this.carWorkshop});
  static route({CarWorkshop? carWorkshop}) => MaterialPageRoute(
        builder: (context) => UpsertCarWorkshopsPage(carWorkshop: carWorkshop),
      );
  @override
  State<UpsertCarWorkshopsPage> createState() => _UpsertCarWorkshopsPageState();
}

class _UpsertCarWorkshopsPageState extends State<UpsertCarWorkshopsPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final carBrandIdController = TextEditingController();

  double? latitude;
  double? longitude;

  GoogleMapController? mapController;
  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(-6.200000, 106.816666), // Jakarta
    zoom: 15,
  );

  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  static const int limit = 50;

  @override
  void initState() {
    super.initState();
    getBrands();
    setState(
      () {
        isUpdate = widget.carWorkshop != null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carWorkshop!.name;
        emailController.text = widget.carWorkshop!.email;
        phoneController.text = widget.carWorkshop!.phoneNumber;
        addressController.text = widget.carWorkshop!.address;
        latitude = widget.carWorkshop!.latitude;
        longitude = widget.carWorkshop!.longitude;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    mapController?.dispose();

    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarWorkshopsCubit>().updateWorkshop(
            CarWorkshop(
              id: widget.carWorkshop?.id,
              name: nameController.text,
              address: addressController.text,
              phoneNumber: phoneController.text,
              email: emailController.text,
              latitude: latitude!,
              longitude: longitude!,
            ),
          );
    } else {
      context.read<CarWorkshopsCubit>().saveWorkshop(
            CarWorkshop(
              name: nameController.text,
              address: addressController.text,
              phoneNumber: phoneController.text,
              email: emailController.text,
              latitude: latitude!,
              longitude: longitude!,
            ),
          );
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      _performAction();
    }
  }

  void getBrands() {
    context.read<CarBrandsCubit>().refresh(limit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarWorkshopsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car workshop ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car Workshops" : "Create Car Workshops",
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
                          ? "Update Car Workshop"
                          : "Create Car Workshop",
                      extent: const Large(),
                    ),
                    MainTextField(
                      controller: nameController,
                      hintText: "Enter workshop name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Workshop name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: emailController,
                      hintText: "Enter email",
                      leadingIcon: const Icon(Icons.email),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: phoneController,
                      hintText: "Enter phone number",
                      leadingIcon: const Icon(Icons.phone),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: addressController,
                      hintText: "Enter address",
                      leadingIcon: const Icon(Icons.location_on),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address cannot be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition:
                            isUpdate && latitude != null && longitude != null
                                ? CameraPosition(
                                    target: LatLng(latitude!, longitude!),
                                    zoom: 15,
                                  )
                                : _defaultLocation,
                        onTap: _onMapTapped,
                        markers: latitude != null && longitude != null
                            ? {
                                Marker(
                                  markerId: const MarkerId('workshop_location'),
                                  position: LatLng(latitude!, longitude!),
                                ),
                              }
                            : {},
                      ),
                    ),
                    if (latitude != null && longitude != null)
                      MainText(
                        text:
                            'Selected Location: ${latitude!.toStringAsFixed(6)}, ${longitude!.toStringAsFixed(6)}',
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
