import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';
import 'package:hotel_app/app/modules/1_home/widgets/offline_widget.dart';
import 'package:hotel_app/app/modules/3_favorite/controllers/favorite_controller.dart';
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
            child: Obx(() {
              // Sinkronisasi teks dengan currentSearchQuery
              searchController.text = controller.currentSearchQuery.value;
              return TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'search location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                onChanged: controller.filterHotels,
                onSubmitted: controller.filterHotels,
              );
            }),
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
    return CustomScrollView(
      slivers: [
        // Bagian judul untuk carousel
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recommended Hotels',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),

        // Carousel hotel rekomendasi
        SliverToBoxAdapter(
          child: CarouselSlider.builder(
            itemCount: controller.randomHotelList.length,
            itemBuilder: (context, index, realIndex) {
              final hotel = controller.randomHotelList[index];
              final rating = hotel['rating'] ?? 0.0;

              return GestureDetector(
                onTap: () {
                  Get.to(() => CardDetailView(hotel: hotel));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          hotel['image'] ?? '',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 400,
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.black.withOpacity(0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel['name'] ?? 'Tidak Dikenal',
                                  style: tema.textTheme.bodyLarge?.copyWith(
                                    fontSize: controller.imageFont,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(1),
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

        // Bagian judul untuk grid
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Discover More',
              style: tema.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),

        // Tampilkan pesan jika tidak ada hotel ditemukan
        if (controller.filteredHotelList.isEmpty)
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.youtube_searched_for,
                      size: 80,
                      color: tema.colorScheme.error,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No hotels found',
                      style: tema.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        color: tema.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Change your search query or try again later',
                      style: tema.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: tema.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

        // GridView untuk daftar hotel
        if (controller.filteredHotelList.isNotEmpty)
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
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Obx(
                                    () {
                                      final favoriteController =
                                          Get.find<FavoriteController>();

                                      // Periksa apakah hotel ada di daftar favorit berdasarkan ID
                                      final isFavorited =
                                          favoriteController.favoriteItems.any(
                                        (item) => item['id'] == hotel['id'],
                                      );

                                      return IconButton(
                                        icon: Icon(
                                          isFavorited
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavorited
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                        onPressed: () {
                                          if (isFavorited) {
                                            // Hapus dari favorit berdasarkan UID unik
                                            favoriteController
                                                .removeFromFavorites(
                                                    hotel['id']);
                                          } else {
                                            // Tambahkan ke favorit
                                            favoriteController
                                                .addToFavorites(hotel);
                                          }
                                        },
                                      );
                                    },
                                  )),
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
                                      style:
                                          tema.textTheme.bodyMedium?.copyWith(
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
