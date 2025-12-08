import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:dribbl_id/news/models/news.dart';
import 'package:dribbl_id/news/widgets/news_card.dart';
import 'package:dribbl_id/news/screens/news_details.dart';
import 'package:dribbl_id/news/screens/news_form.dart';

class NewsEntryListPage extends StatefulWidget {
  const NewsEntryListPage({super.key});

  @override
  State<NewsEntryListPage> createState() => _NewsEntryListPageState();
}

class _NewsEntryListPageState extends State<NewsEntryListPage> {
  Future<List<News>> fetchNews(CookieRequest request) async {
    final response =
        await request.get('http://localhost:8000/news/json/');

    List<News> listNews = [];
    for (var d in response) {
      if (d != null) {
        listNews.add(News.fromJson(d));
      }
    }
    return listNews;
  }

  Future<void> deleteNews(
      CookieRequest request, String id) async {
    final response = await request.post(
      'http://localhost:8000/news/delete-news-ajax/$id/',
      {},
    );

    if (response['status'] == 'success') {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isAdmin = request.jsonData['role'] == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('News List'),
      ),

      // ✅ FAB cuma admin
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewsFormPage(),
                  ),
                );
                setState(() {});
              },
            )
          : null,

      body: FutureBuilder<List<News>>(
        future: fetchNews(request),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada news ditemukan.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final news = snapshot.data![index];

              return NewsCard(
                news: news,

                // ✅ Tap = see details (AMAN, BALIK LAGI)
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: news),
                    ),
                  );
                },

                // ✅ Admin only
                onEdit: isAdmin
                    ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsFormPage(
                              news: news, // <- edit mode
                            ),
                          ),
                        );
                        setState(() {});
                      }
                    : null,

                onDelete: isAdmin
                    ? () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hapus News'),
                            content: const Text(
                                'Yakin mau menghapus news ini?'),
                            actions: [
                              TextButton(
                                child: const Text('Batal'),
                                onPressed: () =>
                                    Navigator.pop(ctx, false),
                              ),
                              TextButton(
                                child: const Text(
                                  'Hapus',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () =>
                                    Navigator.pop(ctx, true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await deleteNews(
                              request, news.id.toString());
                        }
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
