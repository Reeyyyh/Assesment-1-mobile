import 'package:flutter/material.dart';
import 'package:flutter_application/app/modules/2_tripplan/controllers/tripplan_controller.dart';
import '../../components/news_card.dart';
import 'package:get/get.dart';

class TripplanView extends StatelessWidget {
  TripplanView({super.key});

  final String query = 'liburan';
  final TripplanController controller = Get.put(TripplanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: controller.fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
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
