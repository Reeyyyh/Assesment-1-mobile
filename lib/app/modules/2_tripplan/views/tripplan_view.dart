import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/2_tripplan/components/elements/news_loading.dart';
import 'package:hotel_app/app/modules/2_tripplan/components/news_card.dart';
import 'package:hotel_app/app/modules/2_tripplan/controllers/tripplan_controller.dart';


class TripplanView extends StatelessWidget {
  TripplanView({super.key});

  final TripplanController controller = Get.put(TripplanController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          child: AppBar(
            backgroundColor: theme.primaryColor,
            title: const Text(
              'TripNews',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
        ),
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            // Menampilkan skeletonizer saat loading
            return ListView.builder(
              itemCount: 6, // Menampilkan 5 item skeleton sebagai contoh
              itemBuilder: (context, index) {
                return const NewsCardSkeleton(); // Menggunakan widget skeleton baru
              },
            );
          }

          if (controller.newsList.isEmpty) {
            return Center(
              child: Text(
                'No news available.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshNews,
            child: ListView.builder(
              itemCount: controller.newsList.length,
              itemBuilder: (context, index) {
                final news = controller.newsList[index];
                return NewsCard(
                  title: news['title'] ?? 'No title available',
                  description:
                      news['description'] ?? 'No description available',
                  url: news['link'] ?? '',
                  imageUrl: news['image_url'] ?? '',
                  publishedDate: news['pubDate'] != null
                      ? DateTime.tryParse(news['pubDate']) ?? DateTime.now()
                      : DateTime.now(),
                );
              },
            )
          );
        },
      ),
    );
  }
}
