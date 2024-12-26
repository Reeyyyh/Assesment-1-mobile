import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/themes/app_theme_controller.dart';
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

  final ThemeController themeController = Get.find<ThemeController>();

  List<Widget> _buildScreens() {
    return [
      HomeView(),
      TripplanView(),
      QRScanView(),
      FavoriteView(),
      ProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color primaryColor = themeController.isDarkTheme.value
        ? Colors.white
        : Colors.black;

    Color secondaryColor = themeController.isDarkTheme.value
        ? Colors.black
        : Colors.white;

    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: "Home",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.map),
        title: "TripNews",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.qrcode_viewfinder, color: secondaryColor),
        title: "QR Scan",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.heart),
        title: "Favorite",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: "Profile",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.grey,
        textStyle: const TextStyle(fontSize: 14),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());

    Color shadowColor = themeController.isDarkTheme.value
        ? const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3) // dark theme
        : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3);  // light theme

    return Obx(() {
      return PersistentTabView(
        context,
        controller: _tabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        onItemSelected: (index) {
          controller.updateSelectedIndex(index);
        },
        confineToSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: false,
        hideNavigationBarWhenKeyboardAppears: true,
        decoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        navBarStyle: NavBarStyle.style16,
      );
    });
  }
}
