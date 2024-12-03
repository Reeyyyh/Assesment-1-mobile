import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetailController extends GetxController {
  final Map<String, dynamic> hotel;
  var address = ''.obs; // Reactive address variable

  CardDetailController(this.hotel);

  // Fungsi untuk membuka Google Maps ke lokasi hotel
Future<void> openGoogleMaps() async {
    final double? latitude = hotel['latitude'];
    final double? longitude = hotel['longitude'];

    if (latitude != null && longitude != null) {
      try {
        // Melakukan reverse geocoding untuk mendapatkan alamat dari koordinat
        List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks.first; // Ambil alamat pertama

        // Ambil nama alamat dan simpan di reactive variable
        address.value = '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
        
        // Menampilkan Google Maps
        final Uri url = Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
          print("Maps opened with location: ${address.value}");
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

  // Fungsi untuk mendapatkan lokasi pengguna dan menghitung jarak
  Future<void> getUserLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Cek izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission permanently denied.')),
      );
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

    // Tampilkan jarak
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Distance to hotel: ${distance.toStringAsFixed(2)} meters')),
    );

    // Buka rute Google Maps dari pengguna ke hotel
    openRouteInGoogleMaps(position.latitude, position.longitude);
  }


  // Fungsi untuk membuka Google Maps dengan rute dari pengguna ke hotel
  Future<void> openRouteInGoogleMaps(double userLatitude, double userLongitude) async {
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
