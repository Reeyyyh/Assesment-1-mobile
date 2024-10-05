import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true,
        body: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(122, 215, 159, 159),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 40,
                  ),
                  SizedBox(width: 16),
                  Text("Hello Rehan"),
                ],
              ),
              Icon(
                Icons.email,
                size: 40,
              ),
            ],
          ),
        ),

        // Search Bar Container
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),

        // Category title and buttons
        const SizedBox(height: 30), // Add some space
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5), // Add some space
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100, // Atur lebar tombol
                    height: 50, // Atur tinggi tombol
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Populer",
                        style: TextStyle(fontSize: controller.itemCategoryFont),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Modern",
                        style: TextStyle(fontSize: controller.itemCategoryFont),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Beach",
                          style:
                              TextStyle(fontSize: controller.itemCategoryFont)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        // Box for images
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage('assets/hotelLobby.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      4), // Padding around the rating
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(
                                        0.5), // Semi-transparent background
                                    borderRadius: BorderRadius.circular(
                                        8), // Rounded corners
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      SizedBox(width: 2),
                                      Text(
                                        "4.8",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 5), // Add some space between image and title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lobby",
                              style: TextStyle(fontSize: controller.imageFont),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "Jakarta",
                                  style: TextStyle(
                                      fontSize: controller.itemCategoryFont),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Rp 1.200.000", // Harga di sebelah kiri
                                  style: TextStyle(
                                    fontSize: controller.itemCategoryFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // Tambahkan aksi untuk love button di sini
                                  },
                                  icon: const Icon(Icons.favorite_border,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage('assets/hotelPool.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      4), // Padding around the rating
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(
                                        0.5), // Semi-transparent background
                                    borderRadius: BorderRadius.circular(
                                        8), // Rounded corners
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      SizedBox(width: 2),
                                      Text(
                                        "4.8",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pool",
                              style: TextStyle(fontSize: controller.imageFont),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  "Jogja",
                                  style: TextStyle(
                                      fontSize: controller.itemCategoryFont),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "Rp 900.000", // Harga untuk Pool
                                  style: TextStyle(
                                    fontSize: controller.itemCategoryFont,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    // Tambahkan aksi untuk love button di sini
                                  },
                                  icon: const Icon(Icons.favorite_border,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
