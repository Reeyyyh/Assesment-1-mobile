import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          height: 145,
          child: Row(
            children: [
              // Gambar skeleton
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    color: Colors.grey[300], // Warna untuk skeleton
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul skeleton
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.grey[300], // Warna untuk skeleton
                      ),
                      const SizedBox(height: 4),
                      // Tanggal skeleton
                      Container(
                        width: 100,
                        height: 15,
                        color: Colors.grey[300], // Warna untuk skeleton
                      ),
                      const SizedBox(height: 8),
                      // Deskripsi skeleton
                      Container(
                        width: double.infinity,
                        height: 15,
                        color: Colors.grey[300], // Warna untuk skeleton
                      ),
                      const SizedBox(height: 8),
                      // Tombol skeleton
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 80,
                          height: 18,
                          color: Colors.grey[300], // Warna untuk skeleton
                        ),
                      ),
                    ],
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
