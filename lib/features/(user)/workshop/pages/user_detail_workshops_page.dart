import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(user)/financial/pages/user_create_order_page.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailWorkshopsPage extends StatefulWidget {
  final CarWorkshop workshop;
  final VehicleData? vehicleData;
  final List<String> carServices;
  // final String carModelYearId;
  // final String colorId;
  final String carColorId;
  final String carModelId;
  final String carModelColorId;
  final double totalPrice;
  final int totalAllServices;
  final List<File> carColors;

  static Route route({
    required CarWorkshop workshop,
    VehicleData? vehicleData,
    required List<String> carServices,
    // required String carModelYearId,
    // required String colorId,
    // required String carModelColorId,
    required String carColorId,
    required String carModelId,
    required String carModelColorId,
    required double totalPrice,
    required List<File> carColors,
    required int totalAllServices,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserDetailWorkshopsPage(
          workshop: workshop,
          vehicleData: vehicleData,
          carServices: carServices,
          // carModelYearId: carModelYearId,
          // colorId: colorId,
          carColorId: carColorId,
          carModelId: carModelId,
          carModelColorId: carModelColorId,
          totalPrice: totalPrice,
          carColors: carColors,
          totalAllServices: totalAllServices,
        ),
      );
  const UserDetailWorkshopsPage({
    Key? key,
    required this.workshop,
    required this.carColorId,
    required this.carModelId,
    required this.vehicleData,
    required this.carServices,
    // required this.carModelColorId,
    required this.carModelColorId,
    required this.carColors,
    // required this.carModelYearId,
    // required this.colorId,
    required this.totalPrice,
    required this.totalAllServices,
  }) : super(key: key);

  @override
  State<UserDetailWorkshopsPage> createState() =>
      _UserDetailWorkshopsPageState();
}

class _UserDetailWorkshopsPageState extends State<UserDetailWorkshopsPage> {
  static const int limit = 100;
  late final CancelToken _cancelToken;
  static const double _zoomLevel = 14;

  late final GoogleMapController? _mapController;
  // List<String> carServices = [];
  // List<String> selectedServices = [];
  // bool isSelectAll = false;

  // void _toggleService(String serviceId) {
  //   setState(() {
  //     if (selectedServices.contains(serviceId)) {
  //       selectedServices.remove(serviceId);
  //     } else {
  //       selectedServices.add(serviceId);
  //     }
  //     isSelectAll = selectedServices.length == carServices.length;
  //   });
  // }

  // void _toggleAllServices(List<CarService> services) {
  //   setState(() {
  //     isSelectAll = !isSelectAll;
  //     if (isSelectAll) {
  //       selectedServices = services.map((e) => e.id!).toList();
  //     } else {
  //       selectedServices.clear();
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    getCarServices();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _launchGoogleMaps() async {
    final lat = widget.workshop.latitude;
    final lng = widget.workshop.longitude;
    final uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      SnackBarUtil.showSnackBar(
        context: context,
        message: 'Tidak dapat membuka Google Maps',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(widget.workshop.name),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 200,
                        child: GoogleMap(
                          liteModeEnabled: true,
                          onMapCreated: _onMapCreated,
                          mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                          onTap: (LatLng position) {
                            // Klik di mana saja pada map akan membuka Google Maps
                            _launchGoogleMaps();
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              widget.workshop.latitude,
                              widget.workshop.longitude,
                            ),
                            zoom: _zoomLevel,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('workshop_location'),
                              position: LatLng(
                                widget.workshop.latitude,
                                widget.workshop.longitude,
                              ),
                              infoWindow: InfoWindow(
                                title: 'Lokasi Workshop',
                                snippet: 'Ketuk untuk membuka peta',
                                onTap: _launchGoogleMaps,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed,
                              ),
                            ),
                          },
                        ),
                      ),
                    ),
                  ),
                  _buildDetailSection(),
                  // TODO Revisi
                  // StateHandler<CarServicesCubit, PaginationState<CarService>>(
                  //   onRetry: () => getCarServices(),
                  //   onSuccess: (context, data, _) {
                  //     final services = data.data;
                  //     if (carServices.isEmpty && services.isNotEmpty) {
                  //       carServices = services.map((e) => e.id!).toList();
                  //     }

                  //     return RepaintBoundary(
                  //       child: CheckboxServices(
                  //         carServices: services,
                  //         selectedServices: selectedServices,
                  //         isSelectAll: isSelectAll,
                  //         toggleAllServices: _toggleAllServices,
                  //         toggleService: _toggleService,
                  //       ),
                  //     );
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  MainElevatedButton(
                    onPressed: () {
                      // if (selectedServices.isEmpty) {
                      //   SnackBarUtil.showSnackBar(
                      //     context: context,
                      //     message: 'Pilih layanan terlebih dahulu',
                      //     type: SnackBarType.warning,
                      //   );
                      //   return;
                      // }
                      // final totalPrice = (context.read<CarServicesCubit>().state
                      //         as BaseSuccessState<PaginationState<CarService>>)
                      //     .data
                      //     .data
                      //     .where(
                      //       (service) => selectedServices.contains(service.id),
                      //     )
                      //     .fold(
                      //       0,
                      //       (sum, service) => sum + int.parse(service.price),
                      //     );

                      Navigator.of(context).push(
                        UserCreateOrderPage.route(
                          workshopId: widget.workshop.id!,
                          carServices: widget.carServices,
                          carModelColorId: widget.carModelColorId,
                          carColorId: widget.carColorId,
                          carModelId: widget.carModelId,
                          // carModelYearId: widget.carModelYearId,
                          // colorId: widget.colorId,
                          // TODO: REPLACE
                          totalPrice: widget.totalPrice,
                          totalAllServices: widget.totalAllServices,
                          vehicleData: widget.vehicleData,
                          carColors: widget.carColors,
                        ),
                      );
                    },
                    text: "Cat di sini",
                  ).paddingSymmetric(
                    horizontal: 16,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    if (!mounted) return;
    setState(() {
      _mapController = controller;
    });
  }

  Widget _buildDetailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  text: widget.workshop.name,
                  extent: const Large(),
                  color: context.adaptiveTextColor,
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                MainText(
                  text: widget.workshop.distance ?? "N/A",
                  extent: const Medium(),
                  color: context.adaptiveTextColor,
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailItem(
          icon: Icons.location_on,
          label: 'Alamat',
          value: widget.workshop.address,
        ),
        _buildDetailItem(
          icon: Icons.email,
          label: 'Email',
          value: widget.workshop.email,
        ),
        _buildDetailItem(
          icon: Icons.phone,
          label: 'Telepon',
          value: widget.workshop.phoneNumber ?? '-',
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        spacing: 16,
        children: [
          Icon(icon, color: context.adaptiveSecondaryTextColor, size: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: label,
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  color: context.adaptiveTextColor,
                ),
                const SizedBox(height: 4),
                MainText(
                  text: value,
                  color: context.adaptiveSecondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getCarServices() async {
    await context
        .read<CarServicesCubit>()
        .getServices(1, _cancelToken, limit: limit);
  }
}
