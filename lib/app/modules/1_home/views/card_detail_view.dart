import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:hotel_app/app/modules/1_home/controllers/card_detail_controller.dart';

class CardDetailView extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const CardDetailView({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final CardDetailController controller =
        Get.put(CardDetailController(hotel));
    final ConnectivityController connectivityController =
        Get.find<ConnectivityController>(); // Mengakses ConnectivityController
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Obx(() {
        return connectivityController.isOffline.value
            ? _buildOfflineMessage(theme)
            : _buildBody(context, controller, theme);
      }),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.white,
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Detail Hotel',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.primaryColor, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineMessage(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.red.shade50, // Background color for the message
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.red.shade300,
                width: 2), // Border around the message
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.signal_wifi_off, // Icon to represent no connection
                color: Colors.red.shade600,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'No internet connection available. Please check your network.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.red.shade800, // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, CardDetailController controller, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HotelImage(hotel: hotel),
          const SizedBox(height: 16),
          _HotelInfo(hotel: hotel, theme: theme),
          const SizedBox(height: 16),
          _LocationInfo(controller: controller, theme: theme),
          const SizedBox(height: 12),
          _RouteButton(controller: controller, theme: theme),
        ],
      ),
    );
  }
}

class _HotelImage extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const _HotelImage({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        hotel['image'] ?? '',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _HotelInfo extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final ThemeData theme;

  const _HotelInfo({required this.hotel, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotel['name'] ?? 'Unknown',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Price: Rp ${hotel['price'] ?? '0'}",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              hotel['description'] ?? 'No description available.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final CardDetailController controller;
  final ThemeData theme;

  const _LocationInfo({required this.controller, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => controller.locationAddress.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                          controller.locationAddress.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            await controller.getUserGeocoding();
          },
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.my_location, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.userAddress.value.isNotEmpty
                              ? controller.userAddress.value
                              : 'Tap to get your location',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: controller.isError.value ? Colors.red : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _RouteButton extends StatelessWidget {
  final CardDetailController controller;
  final ThemeData theme;

  const _RouteButton({required this.controller, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        controller.openRouteInGoogleMaps(position.latitude, position.longitude);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Show Route to Hotel',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color to match theme
            ),
          ),
        ),
      ),
    );
  }
}
