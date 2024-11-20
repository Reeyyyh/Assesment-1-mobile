import 'package:flutter/cupertino.dart';
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
      icon: const Icon(CupertinoIcons.home), // Ikon Cupertino untuk Home
      title: "Home",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.map), // Ikon Cupertino untuk Map
      title: "Trip Plan",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.qrcode_viewfinder, color: Colors.white,), // Ikon Cupertino QR Scan
      title: "QR Scan",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.heart), // Ikon Cupertino untuk Favorite
      title: "Favorite",
      activeColorPrimary: Colors.blueAccent,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.person), // Ikon Cupertino untuk Profile
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
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        colorBehindNavBar: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
