import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailWorkshopsPage extends StatefulWidget {
  final CarWorkshop workshop;
  static Route route({required CarWorkshop workshop}) => MaterialPageRoute(
        builder: (_) => UserDetailWorkshopsPage(workshop: workshop),
      );
  const UserDetailWorkshopsPage({Key? key, required this.workshop})
      : super(key: key);

  @override
  State<UserDetailWorkshopsPage> createState() =>
      _UserDetailWorkshopsPageState();
}

class _UserDetailWorkshopsPageState extends State<UserDetailWorkshopsPage> {
  late final GoogleMapController? _mapController;
  static const double _zoomLevel = 14;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.workshop.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 24),
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
            value: widget.workshop.phoneNumber,
          ),
          if (widget.workshop.distance != null)
            _buildDetailItem(
              icon: Icons.directions_car,
              label: 'Jarak',
              value: '${widget.workshop.distance} km',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workshop.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
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
                          onMapCreated: _onMapCreated,
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
                                BitmapDescriptor.hueViolet,
                              ),
                            ),
                          },
                          mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      ),
                    ),
                  ),
                  _buildDetailSection(),
                ],
              ),
            ),
          ),
          // Bottom Action Button
        ],
      ),
    );
  }
}
