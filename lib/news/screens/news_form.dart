import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';

import 'package:dribbl_id/news/models/news.dart';

class NewsFormPage extends StatefulWidget {
  final News? news; 

  const NewsFormPage({super.key, this.news});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _content;
  late String _category;
  late String _thumbnail;

  final List<String> _categories = [
    'nba',
    'ibl',
    'fiba',
    'transfer',
    'highlight',
    'analysis',
  ];

  @override
  void initState() {
    super.initState();

    _title = widget.news?.title ?? '';
    _content = widget.news?.content ?? '';
    _category = widget.news?.category ?? '';
    _thumbnail = widget.news?.thumbnail ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isEdit = widget.news != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit News' : 'Add New News'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: "Judul Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? "Judul tidak boleh kosong!"
                          : null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _content,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Isi Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _content = value,
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? "Isi berita tidak boleh kosong!"
                          : null,
                ),
              ),

              // ✅ Category
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: _category.isEmpty ? null : _category,
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(
                              cat[0].toUpperCase() + cat.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => _category = value!,
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? "Kategori wajib dipilih!"
                          : null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _thumbnail,
                  decoration: InputDecoration(
                    labelText: "URL Thumbnail (opsional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _thumbnail = value,
                ),
              ),

              // ✅ SAVE BUTTON
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.black),
                    minimumSize: MaterialStateProperty.all(
                      const Size(double.infinity, 48),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final url = isEdit
                          ? 'http://localhost:8000/news/edit-news-ajax/${widget.news!.id}/'
                          : 'http://localhost:8000/news/create-flutter/';

                      final response = await request.postJson(
                        url,
                        jsonEncode({
                          'title': _title,
                          'content': _content,
                          'category': _category,
                          'thumbnail': _thumbnail,
                        }),
                      );

                      if (context.mounted &&
                          response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(isEdit
                                ? 'News updated!'
                                : 'News created!'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
