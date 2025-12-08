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
    final response = await request.get('http://localhost:8000/news/json/');
    return response.map<News>((d) => News.fromJson(d)).toList();
  }

  Future<void> deleteNews(
      CookieRequest request, String id, BuildContext context) async {
    final response =
        await request.post('http://localhost:8000/news/delete/$id/', {});
    if (response['status'] == 'success') {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isAdmin = request.jsonData['role'] == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('News List')),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewsFormPage()),
                );
                setState(() {});
              },
            )
          : null,
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot<List<News>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada news ditemukan'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final item = snapshot.data![index];

              return NewsCard(
                news: item,
                isAdmin: isAdmin,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: item),
                    ),
                  );
                },
                onEdit: isAdmin
                    ? () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsFormPage(news: item),
                          ),
                        );
                        setState(() {});
                      }
                    : null,
                onDelete: isAdmin
                    ? () async {
                        await deleteNews(request, item.id, context);
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
