import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/views/home_view.dart';
import 'package:hotel_app/app/modules/2_tripplan/views/tripplan_view.dart';
import 'package:hotel_app/app/modules/3_favorite/views/favorite_view.dart';
import 'package:hotel_app/app/modules/4_profile/views/profile_view.dart';
import 'package:hotel_app/app/modules/QrisPage/views/qris_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';


import '../controllers/main_controller.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final PersistentTabController _tabController =
      PersistentTabController(initialIndex: 0);

  // Screens untuk setiap tab
  List<Widget> _buildScreens() {
  return [
    HomeView(),
    TripplanView(),
    QRScanView(), // Tambahkan view baru untuk QR Code Scanner
    FavoriteView(),
    ProfileView(),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: "Home",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.map),
      title: "Trip Plan",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.qr_code, color: Colors.white,),
      title: "QR Scan", // Item untuk QR Scan
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.favorite),
      title: "Favorite",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: "Profile",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    return PersistentTabView(
      context,
      controller: _tabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      onItemSelected: (index) {
        controller.updateSelectedIndex(index); // Update index di controller
      },
      confineToSafeArea: true,
      backgroundColor: Colors.white, // Background warna solid
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: false, // Gunakan GetX untuk state management
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style16, // Gaya navbar
    );
  }
}
