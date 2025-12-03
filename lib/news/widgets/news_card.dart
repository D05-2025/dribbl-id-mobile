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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    news.thumbnail,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Category: ${news.category}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  news.content.length > 100
                      ? '${news.content.substring(0, 100)}...'
                      : news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 6),

                Text(
                  'Posted: ${news.createdAt.toLocal().toString().substring(0, 16)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                // 🔥 TOMBOL ADMIN
                if (isAdmin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
