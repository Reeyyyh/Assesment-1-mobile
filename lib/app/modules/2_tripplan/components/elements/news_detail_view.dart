import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsDetailView extends StatelessWidget {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedDate;
  final String sourceName;
  final String sourceUrl;

  const NewsDetailView({
    super.key,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedDate,
    required this.sourceName,
    required this.sourceUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Berita"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar berita dengan border radius dan shadow
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Judul berita dengan teks besar dan berat
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
              ),
              const SizedBox(height: 8),

              // Tanggal publikasi
              Text(
                'Published on ${DateFormat('yyyy-MM-dd').format(publishedDate)}', // Format hanya tanggal
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),

              // Deskripsi berita dengan padding dan garis bawah
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
