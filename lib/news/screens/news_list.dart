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
  String _selectedCategory = 'All';
  String _selectedSort = 'Terbaru';
  String _searchQuery = '';

  final List<Map<String, String>> _categories = [
    {'value': 'All', 'label': 'All Categories'},
    {'value': 'nba', 'label': 'NBA'},
    {'value': 'ibl', 'label': 'IBL'},
    {'value': 'fiba', 'label': 'FIBA'},
    {'value': 'transfer', 'label': 'Transfers'},
    {'value': 'highlight', 'label': 'Highlights'},
    {'value': 'analysis', 'label': 'Analysis'},
  ];

  Future<List<News>> fetchNews(CookieRequest request) async {
    final response = await request.get('http://localhost:8000/news/json/');
    List<News> listNews = response.map<News>((d) => News.fromJson(d)).toList();

    if (_searchQuery.isNotEmpty) {
      listNews = listNews.where((news) => 
        news.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    if (_selectedCategory != 'All') {
      listNews = listNews.where((news) => 
        news.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    if (_selectedSort == 'Terbaru') {
      listNews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (_selectedSort == 'Terlama') {
      listNews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_selectedSort == 'Judul A-Z') {
      listNews.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (_selectedSort == 'Judul Z-A') {
      listNews.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isAdmin = request.jsonData['role'] == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background sesuai foto
      appBar: AppBar(
        title: const Text('News Feed', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        backgroundColor: Colors.amber, 
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsFormPage())).then((_) => setState(() {})),
        child: const Icon(Icons.add, color: Colors.black),
      ) : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search news...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1E1E1E),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Category',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        value: _selectedCategory,
                        items: _categories.map((cat) => DropdownMenuItem(value: cat['value'], child: Text(cat['label']!))).toList(),
                        onChanged: (v) => setState(() => _selectedCategory = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1E1E1E),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Sort by',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        value: _selectedSort,
                        items: ['Terbaru', 'Terlama', 'Judul A-Z', 'Judul Z-A'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => _selectedSort = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: FutureBuilder(
              future: fetchNews(request),
              builder: (context, AsyncSnapshot<List<News>> snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) return const Center(child: Text('No news found', style: TextStyle(color: Colors.white)));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) {
                    final item = snapshot.data![index];
                    return NewsCard(
                      news: item,
                      isAdmin: isAdmin,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewsDetailPage(news: item))),
                      onEdit: () async { 
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => NewsFormPage(news: item))); 
                        setState(() {}); 
                      },
                      onDelete: () async { 
                        await request.post('http://localhost:8000/news/delete-news-ajax/${item.id}/', {});
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}