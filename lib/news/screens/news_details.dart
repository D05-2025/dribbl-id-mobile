import 'package:flutter/material.dart';
import 'package:dribbl_id/news/models/news.dart';

class NewsDetailPage extends StatelessWidget {
  final News news;

  const NewsDetailPage({super.key, required this.news});

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'News Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.thumbnail.isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    'https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/news/proxy-image/?url=${Uri.encodeComponent(news.thumbnail)}',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0D0D0D).withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. KATEGORI & TANGGAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber, // Warna kontras untuk kategori
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors
                                .black, // Tulisan hitam di atas background amber
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(news.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 3. JUDUL (Warna Putih agar terbaca di background hitam)
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // DIPERBAIKI: Agar tidak hilang
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Divider(color: Colors.white10, thickness: 1),
                  const SizedBox(height: 15),

                  // 4. KONTEN (Warna Putih Abu agar mata tidak cepat lelah)
                  Text(
                    news.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors
                          .white70, // DIPERBAIKI: Menggunakan Putih lembut
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
