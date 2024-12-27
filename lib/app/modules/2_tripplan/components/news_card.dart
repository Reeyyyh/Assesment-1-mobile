import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_app/app/modules/2_tripplan/components/elements/news_detail_view.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedDate;

  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5, // Bayangan untuk efek 3D
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          // Gambar di samping
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[300],
                  child: const Center(
                    child:
                        Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          // Konten teks di samping gambar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul berita
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Tanggal publikasi
                  Text(
                    DateFormat('yyyy-MM-dd')
                        .format(publishedDate), // Format hanya tanggal
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi berita
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Tombol 'Read More'
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                          () => NewsDetailView(
                            title: title,
                            description: description,
                            url: url,
                            imageUrl: imageUrl,
                            publishedDate: publishedDate,
                          ),
                        );
                      },
                      child: Text(
                        'Read more...',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}