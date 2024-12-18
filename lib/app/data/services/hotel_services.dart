import 'package:http/http.dart' as http;
import 'dart:convert';

class HotelService {
  Future<List<dynamic>> fetchNewsData() async {

    const String apikey = 'pub_56254b8d52c0defea09751154ce84a2b12a42';
    const String apiUrl = 'https://newsdata.io/api/1/news?apikey=$apikey&q=liburan';
    //pub_56254b8d52c0defea09751154ce84a2b12a42

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData['results'];
    } else {
      throw Exception('Failed to load news');
    }
  }
}
