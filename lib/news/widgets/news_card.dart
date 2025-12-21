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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, 
        children: [
              Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  news.thumbnail,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(height: 100, color: Colors.grey),
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded( 
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
                            constraints: const BoxConstraints(), 
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

                Text(
                  news.content,
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis, 
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                
                const SizedBox(height: 16),

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