

import 'package:flutter_application/app/modules/2_tripplan/bindings/tripplan_binding.dart';
import 'package:flutter_application/app/modules/2_tripplan/views/tripplan_view.dart';
import 'package:flutter_application/app/modules/3_favorite/bindings/favorite_binding.dart';
import 'package:flutter_application/app/modules/3_favorite/views/favorite_view.dart';

import '../modules/4_profile/bindings/profile_binding.dart';
import '../modules/4_profile/views/profile_view.dart';

import 'package:get/get.dart';

import '../modules/1_home/bindings/home_binding.dart';
import '../modules/1_home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: _Paths.tripplan,
      page: () => TripplanView(),
      binding: TripplanBinding(),
    ),

    GetPage(
      name: _Paths.favorite,
      page: () =>  FavoriteView(),
      binding: FavoriteBinding(),
    ),    

    GetPage(
      name: _Paths.profile,
      page: () =>  ProfileView(),
      binding: ProfileBinding(),
    ),

  ];
}
