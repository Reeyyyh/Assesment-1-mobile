import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetailController extends GetxController {
  final Map<String, dynamic> hotel;
  // Reactive address variable
  var locationAddress = ''.obs;
  var userAddress = ''.obs;
  var distanceBetweenLocation = ''.obs;

  CardDetailController(this.hotel);

  // Fungsi untuk membuka Google Maps ke lokasi hotel
  Future<void> getHotelGeocoding() async {
    final double? latitude = hotel['latitude'];
    final double? longitude = hotel['longitude'];

    if (latitude != null && longitude != null) {
      try {
        // Melakukan reverse geocoding untuk mendapatkan alamat dari koordinat
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks.first; // Ambil alamat pertama

        // Ambil nama alamat dan simpan di reactive variable
        locationAddress.value =
            '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';

        // Menampilkan Google Maps
        final Uri url = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
          print("Maps opened with location: ${locationAddress.value}");
        } else {
          Get.snackbar(
            'Error',
            'Could not open Google Maps.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to get address: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Location data is unavailable.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

Future<void> getUserGeocoding() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek layanan lokasi
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    // Cek dan minta izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permission denied.');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
          'Error', 'Location permission permanently denied. Please enable it.');
      return;
    }

    // Ambil lokasi pengguna
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Lakukan reverse geocoding
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.first;

    // Simpan alamat pengguna ke dalam reactive variable
    userAddress.value =
        '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';

    // Buka lokasi di Google Maps
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl),
          mode: LaunchMode.externalApplication); // Pastikan buka aplikasi eksternal
    } else {
      throw 'Could not open the map.';
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to get user location: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}

  // Fungsi untuk mendapatkan lokasi pengguna dan menghitung jarak
  Future<void> getDistanceLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('disabled', 'Location services are disabled.');
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('denied', 'Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('denied', 'Location permission permanently denied.');
      return;
    }

    // Dapatkan lokasi pengguna
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Hitung jarak antara lokasi pengguna dan hotel
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      hotel['latitude'],
      hotel['longitude'],
    );

    distanceBetweenLocation.value = 'Jarak ke lokasi ${distance.toStringAsFixed(2)} meter';

    // Buka rute Google Maps dari pengguna ke hotel
    openRouteInGoogleMaps(position.latitude, position.longitude);
  }

  // Fungsi untuk membuka Google Maps dengan rute dari pengguna ke hotel
  Future<void> openRouteInGoogleMaps(
      double userLatitude, double userLongitude) async {
    final double? hotelLatitude = hotel['latitude'];
    final double? hotelLongitude = hotel['longitude'];

    if (hotelLatitude != null && hotelLongitude != null) {
      final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$userLatitude,$userLongitude&destination=$hotelLatitude,$hotelLongitude&travelmode=driving',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar(
          'Error',
          'Could not open Google Maps with directions.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Location data is unavailable.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
