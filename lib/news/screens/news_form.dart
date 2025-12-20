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
  // Default category disesuaikan dengan models.py
  String _category = 'nba'; 
  String _thumbnail = '';

  // Opsi kategori diambil langsung dari CATEGORY_CHOICES di models.py
  final List<Map<String, String>> _categoryOptions = [
    {'value': 'nba', 'label': 'NBA'},
    {'value': 'ibl', 'label': 'IBL'},
    {'value': 'fiba', 'label': 'FIBA'},
    {'value': 'transfer', 'label': 'Transfers & Trades'},
    {'value': 'highlight', 'label': 'Game Highlights'},
    {'value': 'analysis', 'label': 'Team & Player Analysis'},
  ];

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
      appBar: AppBar(
        title: Text(isEdit ? 'Edit News' : 'Add New Story'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Share the latest basketball updates",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                
                // Title Field
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter news title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  onChanged: (v) => _title = v,
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),

                // Category Dropdown - Disesuaikan dengan models.py
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categoryOptions.map((opt) {
                    return DropdownMenuItem(
                      value: opt['value'],
                      child: Text(opt['label']!),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 16),

                // Thumbnail Field
                TextFormField(
                  initialValue: _thumbnail,
                  decoration: InputDecoration(
                    labelText: 'Thumbnail URL',
                    hintText: 'https://example.com/image.jpg',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.image),
                  ),
                  onChanged: (v) => _thumbnail = v,
                ),
                const SizedBox(height: 16),

                // Content Field
                TextFormField(
                  initialValue: _content,
                  maxLines: 8,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    alignLabelWithHint: true,
                    hintText: 'Write the full story here...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (v) => _content = v,
                  validator: (v) => v == null || v.isEmpty ? 'Please enter the content' : null,
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isEdit ? 'UPDATE NEWS' : 'PUBLISH NEWS',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final url = isEdit
                            ? 'http://localhost:8000/news/edit-flutter/${widget.news!.id}/'
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

                        if (context.mounted && response['status'] == 'success') {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}