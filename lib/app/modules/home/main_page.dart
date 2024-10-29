import 'package:flutter/material.dart';
import 'package:flutter_application/app/modules/1_home/views/home_view.dart';
import 'package:flutter_application/app/modules/2_tripplan/views/tripplan_view.dart';
import 'package:flutter_application/app/modules/3_favorite/views/favorite_view.dart';
import 'package:flutter_application/app/modules/4_profile/views/profile_view.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final RxInt _selectedIndex = 0.obs;

  final List<Widget> _pages = [
    HomeView(),
    TripplanView(),
    FavoriteView(),
    ProfileView(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[_selectedIndex.value]),
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
                onTap: () => _onItemTapped(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: _selectedIndex.value == index
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
                        size: _selectedIndex.value == index
                            ? 30
                            : 24, // Ukuran ikon
                        color: _selectedIndex.value == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                    // Ubah nilai dari 5 ke 2
                    Text(
                      index == 0
                          ? 'Home'
                          : index == 1
                              ? 'Trip Plan'
                              : index == 2
                                  ? 'Favorite'
                                  : 'Profile',
                      style: TextStyle(
                        color: _selectedIndex.value == index
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
