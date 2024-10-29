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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ), 
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'TripPlan news',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
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
