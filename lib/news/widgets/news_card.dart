import 'package:flutter/material.dart';
import 'package:dribbl_id/news/models/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  });

  // Helper untuk warna kategori agar estetik
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'nba': return Colors.blue;
      case 'ibl': return Colors.green;
      case 'fiba': return Colors.redAccent;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin luar agar card tidak menempel ke pinggir layar
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Background gelap sesuai gambar
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Agar tinggi card menyesuaikan isi
        children: [
          // 1. Gambar dengan Label Kategori di atasnya (Stack)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  news.thumbnail,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(height: 180, color: Colors.grey[800], child: const Icon(Icons.broken_image, color: Colors.white)),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(news.category),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    news.category.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          // 2. Konten Teks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dan Tombol Admin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( // Mencegah judul overflow ke samping
                      child: Text(
                        news.title,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isAdmin)
                      Row(
                        children: [
                          IconButton(
                            constraints: const BoxConstraints(), // Mengecilkan area klik agar hemat tempat
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                            onPressed: onEdit,
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: onDelete,
                          ),
                        ],
                      )
                  ],
                ),
                const SizedBox(height: 8),

                // Isi Konten (PENYEBAB OVERFLOW UTAMA)
                Text(
                  news.content,
                  maxLines: 2, // Membatasi hanya 2 baris agar tidak overflow ke bawah
                  overflow: TextOverflow.ellipsis, // Memberikan efek "..." jika teks kepotong
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                
                const SizedBox(height: 16),

                // 3. Footer: Tanggal & Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          "${news.createdAt.year}-${news.createdAt.month.toString().padLeft(2, '0')}-${news.createdAt.day.toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: const Text("See Details", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}