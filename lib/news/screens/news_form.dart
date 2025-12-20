import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dribbl_id/news/models/news.dart';

class NewsFormPage extends StatefulWidget {
  final News? news;
  const NewsFormPage({super.key, this.news});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  String _category = 'nba'; 
  String _thumbnail = '';

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      _title = widget.news!.title;
      _content = widget.news!.content;
      _category = widget.news!.category;
      _thumbnail = widget.news!.thumbnail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isEdit = widget.news != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit News' : 'Add Story')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                onChanged: (v) => _title = v,
                validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: ['nba', 'ibl', 'fiba', 'transfer', 'highlight', 'analysis']
                    .map((val) => DropdownMenuItem(value: val, child: Text(val.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _thumbnail,
                decoration: const InputDecoration(labelText: 'Thumbnail URL', border: OutlineInputBorder()),
                onChanged: (v) => _thumbnail = v,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Content', border: OutlineInputBorder()),
                onChanged: (v) => _content = v,
                validator: (v) => v == null || v.isEmpty ? 'Content is required' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final url = isEdit
                          ? 'https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/news/edit-news-ajax/${widget.news!.id}/'
                          : 'https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/news/create-flutter/';

                      final response = await request.postJson(
                        url,
                        jsonEncode({
                          'title': _title,
                          'content': _content,
                          'category': _category,
                          'thumbnail': _thumbnail,
                        }),
                      );

                      if (response['status'] == 'success') Navigator.pop(context);
                    }
                  },
                  child: Text(isEdit ? 'UPDATE' : 'PUBLISH'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}