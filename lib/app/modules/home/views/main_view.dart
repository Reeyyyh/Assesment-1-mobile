import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/views/home_view.dart';
import 'package:hotel_app/app/modules/2_tripplan/views/tripplan_view.dart';
import 'package:hotel_app/app/modules/3_favorite/views/favorite_view.dart';
import 'package:hotel_app/app/modules/4_profile/views/profile_view.dart';
import 'package:hotel_app/app/modules/home/controllers/main_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    final List<Widget> pages = [
      HomeView(),
      TripplanView(),
      FavoriteView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () => controller.updateSelectedIndex(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: controller.selectedIndex.value == index
                          ? 50
                          : 40, // Tinggi animasi
                      child: Icon(
                        index == 0
                            ? Icons.home
                            : index == 1
                                ? Icons.map
                                : index == 2
                                    ? Icons.favorite
                                    : Icons.person,
                        size: controller.selectedIndex.value == index
                            ? 30
                            : 24, // Ukuran ikon
                        color: controller.selectedIndex.value == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                    Text(
                      index == 0
                          ? 'Home'
                          : index == 1
                              ? 'Trip Plan'
                              : index == 2
                                  ? 'Favorite'
                                  : 'Profile',
                      style: TextStyle(
                        color: controller.selectedIndex.value == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
