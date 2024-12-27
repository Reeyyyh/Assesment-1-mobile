import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  // Daftar favorit menggunakan RxList agar bisa dipantau perubahan
  final favoriteItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites(); // Ambil data favorit saat controller diinisialisasi
    ever(favoriteItems, (_) {
      // Setiap kali favoriteItems berubah, Anda bisa memanggil setState atau melakukan tindakan lain
      update(); // Memastikan bahwa UI diperbarui saat favoriteItems berubah
    });
  }

  // Ambil data favorit dari Firestore untuk user yang sedang login
  void fetchFavorites() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      favoriteItems.clear(); // Kosongkan daftar jika tidak ada user login
      return;
    }

    final userId = currentUser.uid;
    final favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteHotels');

    try {
      final querySnapshot = await favoritesCollection.get();
      favoriteItems.assignAll(
        querySnapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Tambahkan ID dokumen ke data
          return data;
        }).toList(),
      );
      print("Favorites fetched successfully!");
    } catch (e) {
      print("Failed to fetch favorites: $e");
    }
  }

  // Tambahkan item ke daftar favorit
  void addToFavorites(Map<String, dynamic> hotel) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      Get.snackbar(
        "Login Required",
        "Please login to add items to favorites.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final userId = currentUser.uid;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favoriteHotels')
        .doc(); // ID akan di-generate otomatis oleh Firestore

    try {
      await docRef.set(hotel);
      hotel['id'] = docRef.id; // Menyimpan ID dokumen yang di-generate
      favoriteItems.add(hotel); // Tambahkan ke daftar lokal
      Get.snackbar(
        "Added",
        "${hotel['name']} has been added to favorites.",
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      print("Failed to add to favorites: $e");
    }
  }

void removeFromFavorites(String hotelId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("No user logged in. Cannot remove from favorites.");
    return;
  }

  final userId = currentUser.uid;
  final docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('favoriteHotels')
      .doc(hotelId);

  try {
    // Debug print sebelum penghapusan
    print("Attempting to delete hotel with ID: $hotelId");

    // Hapus item dari Firestore
    await docRef.delete();

    // Debug print setelah penghapusan
    print("Hotel with ID: $hotelId successfully deleted from Firestore");

    // Hapus item dari daftar lokal
    favoriteItems.removeWhere((item) => item['id'] == hotelId);

    // Debug print setelah penghapusan dari daftar lokal
    print("Hotel with ID: $hotelId removed from local favoriteItems list");
  } catch (e) {
    // Tampilkan error jika penghapusan gagal
    print("Failed to remove from favorites: $e");
  }
}

}
