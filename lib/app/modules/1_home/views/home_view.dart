import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshData, // Fungsi untuk pull-to-refresh
        child: Obx(() {
          // Jika data kosong, tampilkan indikator loading atau pesan kosong
          if (controller.hotelList.isEmpty) {
            return const Center(
              child: Text(
                'No hotels available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Jika data tersedia, tampilkan dalam bentuk GridView
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.hotelList.length,
            itemBuilder: (context, index) {
              final hotel = controller.hotelList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Hotel
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
                    // Detail Hotel
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: controller.imageFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                hotel['location'] ?? 'Unknown',
                                style: TextStyle(
                                  fontSize: controller.itemCategoryFont,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Rp ${hotel['price'] ?? '0'}",
                            style: TextStyle(
                              fontSize: controller.itemCategoryFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
