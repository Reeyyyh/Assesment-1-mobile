import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isOffline = false.obs;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    // Memeriksa koneksi pertama kali
    _checkInitialConnectivity();

    // Memantau perubahan status koneksi
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty) {
        checkConnectivity(result.first); // Memeriksa status koneksi pertama kali
      }
    });
  }

  // Fungsi untuk memeriksa koneksi awal
  void _checkInitialConnectivity() async {
    // Mendapatkan hasil dari checkConnectivity tanpa perlu casting
    List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    if (result.isNotEmpty) {
      checkConnectivity(result.first); // Memeriksa status koneksi pertama kali
    }
  }

  // Fungsi untuk memeriksa koneksi dan menampilkan statusnya
  void checkConnectivity(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      isOffline.value = true; // Menandakan aplikasi offline
      print('Status Koneksi: Offline'); // Menampilkan status koneksi offline
    } else {
      isOffline.value = false; // Menandakan aplikasi online
      print('Status Koneksi: Online'); // Menampilkan status koneksi online
    }
  }
}
