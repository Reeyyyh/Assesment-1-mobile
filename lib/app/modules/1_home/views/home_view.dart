import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:hotel_app/app/modules/1_home/widgets/offline_widget.dart';
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
      body: RefreshIndicator(
        onRefresh: controller.refreshData, // Fungsi untuk me-refresh data
        child: Column(
          children: [
            _buildSearchBar(
                searchController, theme), // Tetap tampilkan search bar
            Expanded(
              child: Obx(
                () {
                  // Periksa status koneksi
                  if (connectivityController.isOffline.value) {
                    // Jika offline, hanya tampilkan pesan offline di konten
                    return OfflineMessage(theme: theme);
                  } else {
                    // Ketika online, tampilkan daftar hotel
                    return controller.hotelList.isEmpty
                        ? LoadingIndicator(theme: theme)
                        : _buildHotelGrid(theme);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        child: AppBar(
          backgroundColor:
              theme.primaryColor, // Menggunakan satu warna dari theme
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

  // Jika daftar tidak kosong, tampilkan GridView
  Widget _buildHotelGrid(ThemeData tema) {
    // Periksa apakah daftar hotel yang sudah difilter kosong
    if (controller.filteredHotelList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: tema.colorScheme.error,
              ),
              const SizedBox(height: 20),
              Text(
                'Tidak ada hotel yang ditemukan.',
                style: tema.textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: tema.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Ubah kriteria pencarian Anda.',
                style: tema.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: tema.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Jika daftar tidak kosong, tampilkan GridView
    return CustomScrollView(
      slivers: [
        // Add the "Recommended Hotels" text above the Carousel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recommended Hotels', // The title for the section
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        // CarouselSlider wrapped in a SliverToBoxAdapter to make it scrollable
        SliverToBoxAdapter(
          child: CarouselSlider.builder(
            itemCount: controller.randomHotelList.length,
            itemBuilder: (context, index, realIndex) {
              final hotel = controller.randomHotelList[index];
              final rating = hotel['rating'] ??
                  0.0; // Mengambil rating dari Firebase, default 0.0 jika tidak ada
              return GestureDetector(
                onTap: () {
                  Get.to(() =>
                      CardDetailView(hotel: hotel)); // Navigate to hotel detail
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(30),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          hotel['image'] ?? '',
                          fit: BoxFit.cover,
                        ),
                        // Overlay text on the image
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.black.withOpacity(
                                0.5), // semi-transparent background
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel['name'] ?? 'Tidak Dikenal',
                                  style: tema.textTheme.bodyLarge?.copyWith(
                                    fontSize: controller.imageFont,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // text color white
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      hotel['location'] ?? 'Tidak Dikenal',
                                      style:
                                          tema.textTheme.bodyMedium?.copyWith(
                                        fontSize: controller.itemCategoryFont,
                                        color: Colors.white, // text color white
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Add Rating in the top right corner with background
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.6), // Semi-transparent background for the rating
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow, // Bintang warna kuning
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(
                                      1), // Menampilkan rating dengan 1 angka desimal
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 180,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Discover More', // The title for the section
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),

        // GridView wrapped in SliverGrid
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
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
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              hotel['image'] ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(1.5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.4), // Background color with transparency
                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for the background
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.white),
                                onPressed: () {
                                  // Logika untuk menambahkan hotel ke favorit
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel['name'] ?? 'Tidak Dikenal',
                              style: tema.textTheme.bodyLarge?.copyWith(
                                fontSize: controller.imageFont,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: tema.colorScheme.error, size: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    hotel['location'] ?? 'Tidak Dikenal',
                                    style: tema.textTheme.bodyMedium?.copyWith(
                                      fontSize: controller.itemCategoryFont,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Rp ${hotel['price'] ?? '0'}",
                              style: tema.textTheme.bodyMedium?.copyWith(
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
            childCount: controller.filteredHotelList.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
        ),
      ],
    );
  }
}
