// ignore_for_file: require_trailing_commas

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/map_location.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:paint_car/ui/validator/number_validator.dart';

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
  static const double zoomLevel = 5;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final carBrandIdController = TextEditingController();
  Timer? _debounce;

  double? latitude;
  double? longitude;

  // Instance MapUtils untuk keperluan peta
  late MapUtils mapUtils;

  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  static const int limit = 50;

  @override
  void initState() {
    super.initState();
    // Inisialisasi MapUtils
    mapUtils = MapUtils(zoomLevel: zoomLevel);
    getBrands();
    isUpdate = widget.carWorkshop != null;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isUpdate) {
        setState(() {
          latitude = widget.carWorkshop!.latitude;
          longitude = widget.carWorkshop!.longitude;
        });
        nameController.text = widget.carWorkshop!.name;
        emailController.text = widget.carWorkshop!.email;
        phoneController.text = widget.carWorkshop!.phoneNumber;
        addressController.text = widget.carWorkshop!.address;
      } else {
        // Ambil lokasi saat ini menggunakan MapUtils
        final currentLocation = await mapUtils.getCurrentLocation();
        if (currentLocation != null) {
          setState(() {
            latitude = currentLocation.latitude;
            longitude = currentLocation.longitude;
            addressController.text = currentLocation.address;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    // Daftarkan controller ke MapUtils
    mapUtils.onMapCreated(controller);
    // Jika data workshop sudah ada, geser kamera ke lokasinya
    if (isUpdate) {
      mapUtils.animateToLocation(latitude!, longitude!);
    }
  }

  void _onMapTapped(LatLng position) async {
    final tappedLocation = await mapUtils.onMapTapped(position);
    if (tappedLocation != null) {
      setState(() {
        latitude = tappedLocation.latitude;
        longitude = tappedLocation.longitude;
        addressController.text = tappedLocation.address;
      });
    }
  }

  // Fungsi untuk update lokasi berdasarkan alamat yang diinput
  Future<void> _updateCoordinatesFromAddress(String address) async {
    final location = await mapUtils.getCoordinatesFromAddress(address);
    if (location != null) {
      setState(() {
        latitude = location.latitude;
        longitude = location.longitude;
      });
    }
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
                      validator: numberValidator,
                      keyboardType: TextInputType.phone,
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          flex: 8,
                          child: MainTextField(
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
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }
                              _debounce = Timer(
                                const Duration(milliseconds: 500),
                                () {
                                  if (value.isNotEmpty) {
                                    _updateCoordinatesFromAddress(value);
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: IconButton(
                              color: Theme.of(context).colorScheme.onPrimary,
                              onPressed: () async {
                                final currentLocation =
                                    await mapUtils.getCurrentLocation();
                                if (currentLocation != null) {
                                  setState(() {
                                    latitude = currentLocation.latitude;
                                    longitude = currentLocation.longitude;
                                    addressController.text =
                                        currentLocation.address;
                                  });
                                }
                              },
                              icon: const Icon(Icons.my_location),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition:
                            (latitude != null && longitude != null)
                                ? CameraPosition(
                                    target: LatLng(latitude!, longitude!),
                                    zoom: zoomLevel,
                                  )
                                : MapUtils.defaultLocation,
                        onTap: _onMapTapped,
                        markers: {
                          if (latitude != null && longitude != null)
                            Marker(
                              markerId: const MarkerId('workshop_location'),
                              position: LatLng(latitude!, longitude!),
                            ),
                        },
                      ),
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
