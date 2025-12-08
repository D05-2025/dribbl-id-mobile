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
  late Future<List<News>> _newsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final request = context.read<CookieRequest>();
    _newsFuture = fetchNews(request);
  }

  // ✅ FETCH
  Future<List<News>> fetchNews(CookieRequest request) async {
    final response =
        await request.get('http://localhost:8000/news/json/');

    final response = await request.get('http://localhost:8000/news/json/');
    List<News> listNews = [];
    for (var d in response) {
      listNews.add(News.fromJson(d));
    }
    return listNews;
  }

  // ✅ DELETE
  Future<void> deleteNews(
      CookieRequest request, String id) async {
    await request.post(
      'http://localhost:8000/news/delete-news-ajax/$id/',
      {},
    );
  }

  void refreshList(CookieRequest request) {
    setState(() {
      _newsFuture = fetchNews(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isAdmin = request.jsonData["role"] == "admin";

    return Scaffold(
      appBar: AppBar(title: const Text('News List')),

      // ✅ tambah news
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
                refreshList(request);
              },
            )
          : null,

      body: FutureBuilder(
        future: _newsFuture,
        builder: (context, AsyncSnapshot<List<News>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada news.'),
            );
          }

          final newsList = snapshot.data!;

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final news = newsList[index];

              return NewsCard(
                news: news,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NewsDetailPage(news: news),
                    ),
                  );
                },

                // ✅ ADMIN ONLY
                onEdit: isAdmin
                    ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                NewsFormPage(news: news),
                          ),
                        );
                        refreshList(request);
                      }
                    : null,

                onDelete: isAdmin
                    ? () async {
                        final confirm =
                            await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title:
                                const Text("Hapus berita?"),
                            content: const Text(
                                "Aksi ini tidak bisa dibatalkan."),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, false),
                                child:
                                    const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, true),
                                child:
                                    const Text("Hapus"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await deleteNews(
                              request, news.id);
                          refreshList(request);
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
