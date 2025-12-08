import 'package:flutter/material.dart';
import 'package:dribbl_id/news/models/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const NewsCard({
    super.key,
    required this.news,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool showAdminActions = onEdit != null || onDelete != null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,

        title: Text(
          news.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            news.content.length > 80
                ? '${news.content.substring(0, 80)}...'
                : news.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // ✅ admin-only buttons (auto hidden for user)
        trailing: showAdminActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit News',
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete News',
                      onPressed: onDelete,
                    ),
                ],
              )
            : null,
      ),
    );
  }
}
