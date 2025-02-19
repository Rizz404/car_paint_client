import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(user)/financial/pages/user_create_order_page.dart';
import 'package:paint_car/features/(user)/workshop/widgets/checkbox_services.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailWorkshopsPageOld extends StatefulWidget {
  final CarWorkshop workshop;
  static Route route({required CarWorkshop workshop}) => MaterialPageRoute(
        builder: (_) => UserDetailWorkshopsPageOld(workshop: workshop),
      );
  const UserDetailWorkshopsPageOld({Key? key, required this.workshop})
      : super(key: key);

  @override
  State<UserDetailWorkshopsPageOld> createState() =>
      _UserDetailWorkshopsPageOldState();
}

class _UserDetailWorkshopsPageOldState extends State<UserDetailWorkshopsPageOld>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static const int limit = 100;
  late final CancelToken _cancelToken;
  static const double _zoomLevel = 14;

  // ignore: unused_field
  late final GoogleMapController? _mapController;
  List<String> carServices = [];
  List<String> selectedServices = [];
  bool isSelectAll = false;

  void _toggleService(String serviceId) {
    setState(() {
      if (selectedServices.contains(serviceId)) {
        selectedServices.remove(serviceId);
      } else {
        selectedServices.add(serviceId);
      }
      // Update status select all
      isSelectAll = selectedServices.length == carServices.length;
    });
  }

  void _toggleAllServices(List<CarService> services) {
    setState(() {
      isSelectAll = !isSelectAll;
      if (isSelectAll) {
        selectedServices = services.map((e) => e.id!).toList();
      } else {
        selectedServices.clear();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(widget.workshop.name),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Map Section
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
                  StateHandler<CarServicesCubit, PaginationState<CarService>>(
                    onRetry: () => getCarServices(),
                    onSuccess: (context, data, _) {
                      final services = data.data;
                      // Update langsung tanpa post-frame callback
                      // Pindah ke initState jika memungkinkan
                      if (carServices.isEmpty && services.isNotEmpty) {
                        carServices = services.map((e) => e.id!).toList();
                      }

                      return RepaintBoundary(
                        child: CheckboxServices(
                          carServices: services,
                          selectedServices: selectedServices,
                          isSelectAll: isSelectAll,
                          toggleAllServices: _toggleAllServices,
                          toggleService: _toggleService,
                        ),
                      );
                    },
                  ),
                  MainElevatedButton(
                    onPressed: () {
                      if (selectedServices.isEmpty) {
                        SnackBarUtil.showSnackBar(
                          context: context,
                          message: 'Pilih layanan terlebih dahulu',
                          type: SnackBarType.warning,
                        );
                        return;
                      }

                      Navigator.of(context).push(
                        UserCreateOrderPage.route(
                          workshopId: widget.workshop.id!,
                          carServices: selectedServices,
                        ),
                      );
                    },
                    text: "Cat di sini",
                  ),
                ],
              ),
            ),
          ),
          // Bottom Action Button
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
                ),
                MainText(
                  text: widget.workshop.distance ?? "N/A",
                  color: Theme.of(context).colorScheme.primary,
                  extent: const Medium(),
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
          Icon(icon, color: Colors.grey.shade600, size: 26),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: label,
                ),
                const SizedBox(height: 4),
                MainText(
                  text: value,
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
