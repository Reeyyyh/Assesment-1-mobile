import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var itemCategoryFont = 14.0;
  var imageFont = 24.0;

  var hotelList = [].obs;

  // Real-time listener for Firestore
  void fetchHotelsRealtime() {
    FirebaseFirestore.instance.collection('datahotel').snapshots().listen(
      (snapshot) {
        hotelList.value = snapshot.docs.map((doc) => doc.data()).toList();
      },
      onError: (error) {
        print("Error fetching data in real-time: $error");
      },
    );
  }

  // Manual refresh function
  Future<void> refreshData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('datahotel').get();
      hotelList.value = snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error refreshing data: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHotelsRealtime(); // Start real-time listener
  }
}
