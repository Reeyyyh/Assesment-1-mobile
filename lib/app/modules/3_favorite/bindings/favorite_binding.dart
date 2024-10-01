import 'package:flutter_application/app/modules/3_favorite/controllers/favorite_controller.dart';
import 'package:get/get.dart';



class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoriteController>(
      () => (FavoriteController()),
    );
  }
}
