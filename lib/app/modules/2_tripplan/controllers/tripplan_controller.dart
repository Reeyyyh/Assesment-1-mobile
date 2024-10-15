import 'package:get/get.dart';
import '../../../data/services/hotel_services.dart';

class TripplanController extends GetxController {
  final HotelService _hotelService = HotelService();
  
  Future<List<dynamic>> fetchNews() async {
    try {
      return await _hotelService.fetchNewsData();
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
