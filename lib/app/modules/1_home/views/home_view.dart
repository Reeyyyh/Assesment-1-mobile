import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../controllers/home_controller.dart';
import 'card_detail_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ConnectivityController connectivityController =
      Get.find<ConnectivityController>(); // Mengakses ConnectivityController

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Column(
        children: [
          _buildSearchBar(
              searchController, theme), // Tetap tampilkan search bar
          Expanded(
            child: Obx(
              () {
                // Periksa status koneksi
                if (connectivityController.isOffline.value) {
                  // Jika offline, hanya tampilkan pesan offline di konten
                  return _buildOfflineMessage(theme);
                } else {
                  // Ketika online, tampilkan daftar hotel
                  return RefreshIndicator(
                    onRefresh: controller.refreshData,
                    child: controller.hotelList.isEmpty
                        ? _buildLoadingIndicator(theme)
                        : _buildHotelGrid(theme),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan status offline
  Widget _buildOfflineMessage(ThemeData theme) {
    return Center(
      // Menempatkan seluruh widget di tengah layar
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Menyesuaikan ukuran hanya sebesar kontennya
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 100,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! No Internet Connection',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Please check your connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Loading indicator saat online
  Widget _buildLoadingIndicator(ThemeData theme) {
    // Periksa apakah data sedang dimuat
    if (controller.isLoading.value) {
      // Jika data sedang dimuat, tampilkan loading
      return Center(
        child: CircularProgressIndicator(
          color: theme.primaryColor,
        ),
      );
    } else {
      // Jika data selesai dimuat tapi kosong, tampilkan pesan kosong
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Belum ada hotel yang tersedia.',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Home',
            style: theme.appBarTheme.titleTextStyle?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildSearchBar(
      TextEditingController searchController, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari lokasi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              onChanged: controller.filterHotels,
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic, color: theme.iconTheme.color),
            onPressed: () async {
              try {
                bool available = await _speech.initialize();
                if (available) {
                  _speech.listen(
                    onResult: (result) {
                      searchController.text = result.recognizedWords;
                      controller.filterHotels(searchController.text);
                    },
                  );
                }
              } catch (e) {
                Get.snackbar("Error", "Speech recognition failed: $e");
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHotelGrid(ThemeData theme) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: controller.filteredHotelList.length,
        itemBuilder: (context, index) {
          final hotel = controller.filteredHotelList[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => CardDetailView(hotel: hotel));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: Image.network(
                        hotel['image'] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel['name'] ?? 'Unknown',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: controller.imageFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: theme.colorScheme.error, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              hotel['location'] ?? 'Unknown',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: controller.itemCategoryFont,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Rp ${hotel['price'] ?? '0'}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: controller.itemCategoryFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
