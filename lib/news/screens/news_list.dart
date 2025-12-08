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
    List<News> listNews = [];
    for (var d in response) {
      if (d != null) {
        listNews.add(News.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('News List')),
      floatingActionButton: 
        request.jsonData["role"] == 'admin' 
            ? FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewsFormPage(),
                  ),
                );
              },

                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      body: FutureBuilder(
        future: fetchNews(request),
        builder: (context, AsyncSnapshot<List<News>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada news ditemukan.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final item = snapshot.data![index];
              return NewsCard(
                news: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsDetailPage(news: item),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
