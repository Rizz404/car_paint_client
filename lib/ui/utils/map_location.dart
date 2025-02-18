// map_utils.dart
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

/// Class untuk menampung data lokasi.
class MapLocation {
  final double latitude;
  final double longitude;
  final String address;

  MapLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

/// Class utilitas untuk semua yang berhubungan dengan Google Map.
class MapUtils {
  final double zoomLevel;
  GoogleMapController? mapController;

  MapUtils({this.zoomLevel = 15.0});

  /// Posisi default (misalnya Jakarta)
  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 15.0,
  );

  /// Callback ketika Google Map sudah dibuat.
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Mengambil lokasi saat ini beserta alamatnya, dan jika mapController tersedia,
  /// kamera akan digeser ke lokasi tersebut.
  Future<MapLocation?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition();
        double lat = position.latitude;
        double lng = position.longitude;

        // Geser kamera ke lokasi saat ini jika mapController tersedia.
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(lat, lng),
              zoomLevel,
            ),
          );
        }

        // Dapatkan alamat dari koordinat.
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
        String address = '';
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
        }
        return MapLocation(latitude: lat, longitude: lng, address: address);
      }
    } catch (e) {
      LogService.e('Error getting current location: $e');
    }
    return null;
  }

  /// Mengonversi alamat ke koordinat dan menggeser kamera ke lokasi tersebut.
  Future<MapLocation?> getCoordinatesFromAddress(String address) async {
    try {
      List locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double lat = locations[0].latitude;
        double lng = locations[0].longitude;

        // Geser kamera jika mapController tersedia.
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(lat, lng),
              zoomLevel,
            ),
          );
        }
        return MapLocation(latitude: lat, longitude: lng, address: address);
      }
    } catch (e) {
      LogService.e('Error converting address to coordinates: $e');
    }
    return null;
  }

  /// Mengonversi koordinat ke alamat.
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
      }
    } catch (e) {
      LogService.e('Error converting coordinates to address: $e');
    }
    return null;
  }

  /// Menggeser kamera ke lokasi yang diberikan.
  void animateToLocation(double lat, double lng) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), zoomLevel),
      );
    }
  }

  /// Event ketika peta ditekan (onMapTapped). Mengembalikan lokasi beserta alamatnya.
  Future<MapLocation?> onMapTapped(LatLng position) async {
    try {
      double lat = position.latitude;
      double lng = position.longitude;
      String? address = await getAddressFromCoordinates(lat, lng);
      return MapLocation(
        latitude: lat,
        longitude: lng,
        address: address ?? '',
      );
    } catch (e) {
      LogService.e('Error converting tapped position to address: $e');
      return null;
    }
  }
}
