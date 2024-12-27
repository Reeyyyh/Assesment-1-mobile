import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/1_home/views/card_detail_view.dart';
import 'package:hotel_app/app/modules/3_favorite/controllers/favorite_controller.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({super.key});
  final FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Ambil tema aktif

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: AppBar(
            backgroundColor: theme.primaryColor, // Menggunakan warna dari tema
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            elevation: 0, // Menghilangkan shadow
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Obx(() {
          // Debug print saat daftar favorit diperbarui
          print("Current favorite items: ${controller.favoriteItems.length}");

          if (controller.favoriteItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Agar kolom tidak memenuhi seluruh layar
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border, // Ikon hati kosong
                    size: 80,
                    color: theme.primaryColor
                        .withOpacity(0.5), // Warna yang lebih lembut
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No favorites yet.",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color
                          ?.withOpacity(0.6), // Warna teks lebih lembut
                      fontSize: 24, // Ukuran teks lebih besar
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your favorite hotels here!",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.favoriteItems.length,
            itemBuilder: (context, index) {
              final item = controller.favoriteItems[index];
              return Dismissible(
                key: Key(item['id'].toString()), // Pastikan id item unik
                direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
                onDismissed: (direction) {
                  // Hapus item dari daftar favorit
                  Get.find<FavoriteController>()
                      .removeFromFavorites(item['id']);

                  // Tampilkan snackbar atau notifikasi
                  Get.snackbar(
                    "Removed",
                    "${item['name']} has been removed from favorites.",
                    snackPosition: SnackPosition.TOP,
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10.0),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: FavoriteItemCard(item: item, index: index),
              );
            },
          );
        }),
      ),
    );
  }
}

class FavoriteItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int index;

  const FavoriteItemCard({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final itemName = item['name'] ?? 'Unknown';
    final itemImage = item['image'] ?? '';
    final itemLocation = item['location'] ?? 'Unknown Location';
    final itemPrice = item['price'] ?? 'Price not available';
    final itemRating = item['rating'] ?? 0.0;

    return GestureDetector(
      onTap: () {
        // Navigasi ke CardDetailView dengan data hotel
        Get.to(() => CardDetailView(hotel: item));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(itemImage),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          itemLocation,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        if (index < itemRating.floor()) {
                          return const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 18,
                          );
                        } else if (index < itemRating) {
                          return const Icon(
                            Icons.star_half,
                            color: Colors.orange,
                            size: 18,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Colors.grey,
                            size: 18,
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp $itemPrice',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_left_sharp,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}