import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/data/connections/controllers/connectivity_controller.dart';

class HomeController extends GetxController {
  var itemCategoryFont = 14.0;
  var imageFont = 24.0;

  var hotelList = [].obs;
  var filteredHotelList = [].obs;
  var isLoading = true.obs; // Status loading

  final ConnectivityController connectivityController =
      Get.find<ConnectivityController>();

  // Real-time listener for Firestore
  void fetchHotelsRealtime() {
    isLoading.value = true;
    FirebaseFirestore.instance.collection('datahotel').snapshots().listen(
      (snapshot) {
        hotelList.value = snapshot.docs.map((doc) => doc.data()).toList();
        filteredHotelList.value = hotelList;
        isLoading.value = false; // Selesai memuat data
      },
      onError: (error) {
        print("Error fetching data in real-time: $error");
        isLoading.value = false; // Error juga dianggap selesai
      },
    );
  }

  // Filter berdasarkan lokasi
  void filterHotels(String query) {
    query = query.toLowerCase();
    filteredHotelList.value = hotelList.where((hotel) {
      var location = hotel['location']?.toLowerCase() ?? '';
      return location.contains(query);
    }).toList();

    print('Jumlah hasil filter: ${filteredHotelList.length}'); // Debugging hasil filter
  }

  // Manual refresh function
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('datahotel').get();
      hotelList.value = snapshot.docs.map((doc) => doc.data()).toList();
      filteredHotelList.value = hotelList;
    } catch (e) {
      print("Error refreshing data: $e");
    } finally {
      isLoading.value = false; // Pastikan status loading diatur ulang
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHotelsRealtime();

    connectivityController.isOffline.listen((isOffline) async {
      if (!isOffline) {
        // Jika online, tambahkan delay 1 detik dan kemudian refresh data
        await Future.delayed(const Duration(seconds: 1));
        refreshData();
      }
    });
  }
}
