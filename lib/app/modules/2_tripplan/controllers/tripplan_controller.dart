import 'package:get/get.dart';
import '../../../data/services/hotel_services.dart';

class TripplanController extends GetxController {
  final HotelService _hotelService = HotelService();

  var newsList = <dynamic>[].obs; // Observable list untuk news
  var isLoading = false.obs; // Observable untuk status loading

  @override
  void onInit() {
    super.onInit();
    fetchNews(); // Panggil fetchNews saat controller diinisialisasi
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    try {
      final fetchedNews = await _hotelService.fetchNewsData();
      newsList.assignAll(fetchedNews); // Isi data ke newsList
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch news: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchNews(); // Panggil ulang fetchNews
  }
}
