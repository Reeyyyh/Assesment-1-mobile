import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final RxList<Map<String, String>> favoriteItems = [
    {
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiyD4NxX_VKaLSn3Bop7YDzbZLKrohJkuoig&s',
      'title': 'Luxury Hotel',
      'location': 'Jakarta, Indonesia',
      'price': 'Rp 1.000.000 per malam',
    },
    {
      'image': 'https://ekabo.bogorkab.go.id/uploads/63f481ff754d2_1676968447.jpg',
      'title': 'Mountain Resort',
      'location': 'Yogyakarta, Indonesia',
      'price': 'Rp 750.000 per malam',
    },
    {
      'image': 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/79/38/e2/beach--v17142270.jpg?w=700&h=-1&s=1',
      'title': 'Beach Paradise',
      'location': 'Bali, Indonesia',
      'price': 'Rp 300.000 per malam',
    },
    {
    'image': 'https://img.id.my-best.com/content_section/beforehand_tips/67f9313f6d538e6eb98d94486c99ff72.jpeg?ixlib=rails-4.3.1&q=70&lossless=0&w=690&fit=max&s=b0dbb0570101699f0a6af4d8ac1ac4e3',
    'title': 'New Resort',
    'location': 'Bandung, Indonesia',
    'price': 'Rp 500.000 per malam',
    },
  ].obs;

  void removeItem(int index) {
    favoriteItems.removeAt(index);
  }

}