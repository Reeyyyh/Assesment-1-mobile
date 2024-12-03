import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/controllers/card_detail_controller.dart';

class CardDetailView extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const CardDetailView({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CardDetailController(hotel));

    return Scaffold(
      appBar: AppBar(
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                hotel['image'] ?? '',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hotel['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Price: Rp ${hotel['price'] ?? '0'}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  hotel['description'] ?? 'No description available.',
                  style: const TextStyle(
                      fontSize: 16, height: 1.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const Divider(
              thickness: 3,
              height: 20,
              indent: 10,
              endIndent: 10,
              color: Colors.orangeAccent,
            ),

            GestureDetector(
              onTap: controller
                  .getHotelGeocoding, // Fungsi yang akan dipanggil saat di-tap
              child: Container(
                padding:
                    const EdgeInsets.all(12.0), // Memberikan jarak di dalam box
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang box
                  borderRadius:
                      BorderRadius.circular(10), // Membuat sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2), // Posisi shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.locationAddress.isNotEmpty
                              ? controller.locationAddress.value
                              : 'Tap untuk mendapatkan lokasi tujuan',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: controller
                  .getUserGeocoding, // Panggil fungsi geocoding pengguna
              child: Container(
                padding: const EdgeInsets.all(12.0), // Jarak di dalam box
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang box
                  borderRadius: BorderRadius.circular(10), // Sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2), // Posisi shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.userAddress.isNotEmpty
                              ? controller.userAddress.value
                              : 'Tap untuk mendapatkan lokasi Anda',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12.0), // Jarak di dalam box
              decoration: BoxDecoration(
                color: Colors.white, // Warna latar belakang box
                borderRadius: BorderRadius.circular(10), // Sudut membulat
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna shadow
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // Posisi shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.explore, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Obx(
                      () => Text(
                        controller.distanceBetweenLocation.isNotEmpty
                            ? controller.distanceBetweenLocation.value
                            : 'Jarak lokasi',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              thickness: 3,
              height: 20,
              indent: 10,
              endIndent: 10,
              color: Colors.orangeAccent,
            ),

            // Tombol untuk mendapatkan lokasi dan menghitung jarak
            Center(
              child: Container(
                padding: const EdgeInsets.all(
                    8.0), // Memberikan jarak di sekitar tombol
                decoration: BoxDecoration(
                  color: Colors.white, // Warna latar belakang container
                  borderRadius:
                      BorderRadius.circular(12), // Membuat sudut membulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Warna shadow
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3), // Posisi shadow
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.map_rounded,
                    color: Colors.white,
                    size: 20, // Ukuran ikon
                  ),
                  onPressed: () => controller.getDistanceLocation(context),
                  label: const Text(
                    'Jarak ke lokasi',
                    style: TextStyle(fontSize: 16), // Ukuran teks
                  ),
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(
                        Colors.blue), // Warna latar belakang tombol
                    foregroundColor: const WidgetStatePropertyAll(
                        Colors.white), // Warna teks tombol
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Membulatkan sudut tombol
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
