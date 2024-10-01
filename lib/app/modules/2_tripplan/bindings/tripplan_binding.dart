
import 'package:flutter_application/app/modules/2_tripplan/controllers/TripPlan_controller.dart';
import 'package:get/get.dart';

class TripplanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripplanController>(
      () => TripplanController(),
    );
  }
}
