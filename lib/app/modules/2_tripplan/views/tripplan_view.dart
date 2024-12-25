import 'package:flutter/material.dart';
import 'package:hotel_app/app/modules/2_tripplan/controllers/tripplan_controller.dart';
import '../../components/news_card.dart';
import 'package:get/get.dart';

class TripplanView extends StatelessWidget {
  TripplanView({super.key});

  final String query = 'liburan';
  final TripplanController controller = Get.put(TripplanController());

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
            backgroundColor:
                theme.primaryColor, // Menggunakan satu warna dari tema
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'TripPlan News',
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
      body: FutureBuilder<List<dynamic>>(
        future: controller.fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error, // Sesuaikan dengan tema
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No news available.'),
            );
          }

          final newsList = snapshot.data!;

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];
              return NewsCard(
                title: news['title'],
                description: news['description'] ?? 'No description available',
                url: news['link'],
                imageUrl:
                    news['image_url'] ?? 'https://via.placeholder.com/150',
              );
            },
          );
        },
      ),
    );
  }
}
