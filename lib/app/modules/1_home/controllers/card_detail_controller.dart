import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetailController extends GetxController {
  final Map<String, dynamic> hotel;
  var locationAddress = ''.obs;
  var userAddress = ''.obs;
  var distanceBetweenLocation = ''.obs;
  var isLoading = false.obs;
  var isError = false.obs;

  CardDetailController(this.hotel);

  @override
  void onInit() {
    super.onInit();
    getHotelGeocoding(); // Mendapatkan lokasi hotel
  }

  // Fungsi untuk mendapatkan alamat hotel dari Firebase
  Future<void> getHotelGeocoding() async {
    final double? latitude = hotel['latitude'];
    final double? longitude = hotel['longitude'];

    if (latitude != null && longitude != null) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        Placemark place = placemarks.first;
        locationAddress.value =
            '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}';
        isError.value = false;
      } catch (e) {
        locationAddress.value = 'Gagal mendapatkan alamat hotel';
        isError.value = true;
      }
    } else {
      locationAddress.value = 'Data lokasi hotel tidak tersedia';
      isError.value = true;
    }
  }

  // Fungsi untuk mendapatkan lokasi pengguna
  Future<void> getUserGeocoding() async {
    isLoading.value = true; // Aktifkan loading
    try {
      // Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userAddress.value =
            'Layanan lokasi dinonaktifkan. Aktifkan layanan lokasi untuk melanjutkan.';
        isError.value = true;
        return;
      }

      // Cek izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userAddress.value =
              'Izin lokasi ditolak. Harap izinkan lokasi untuk melanjutkan.';
          isError.value = true;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        userAddress.value =
            'Izin lokasi ditolak secara permanen. Harap aktifkan izin di pengaturan perangkat.';
        isError.value = true;
        return;
      }

      // Dapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Konversi koordinat ke alamat
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks.first;

      userAddress.value = '${place.name}, ${place.street}, ${place.locality}, '
          '${place.administrativeArea}, ${place.country}, ${place.postalCode}';
      isError.value = false; // Tidak ada error
    } catch (e) {
      userAddress.value = 'Gagal mendapatkan lokasi pengguna.';
      isError.value = true; // Set status error
    } finally {
      isLoading.value = false; // Matikan loading
    }
  }

  // Fungsi untuk menghitung jarak antara lokasi pengguna dan hotel
  // Future<void> getDistanceLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       distanceBetweenLocation.value = 'Layanan lokasi dinonaktifkan';
  //       isError.value = true;
  //       return;
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         distanceBetweenLocation.value = 'Izin lokasi ditolak';
  //         isError.value = true;
  //         return;
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     final double? latitude = hotel['latitude'];
  //     final double? longitude = hotel['longitude'];

  //     if (latitude != null && longitude != null) {
  //       double distanceInMeters = Geolocator.distanceBetween(
  //           position.latitude, position.longitude, latitude, longitude);
  //       double distanceInKilometers = distanceInMeters / 1000;
  //       distanceBetweenLocation.value =
  //           '${distanceInKilometers.toStringAsFixed(2)} km';
  //       isError.value = false;
  //     } else {
  //       distanceBetweenLocation.value = 'Data lokasi hotel tidak tersedia';
  //       isError.value = true;
  //     }
  //   } catch (e) {
  //     distanceBetweenLocation.value = 'Gagal mendapatkan jarak ke lokasi';
  //     isError.value = true;
  //   }
  // }

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
