import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:dribbl_id/news/models/news.dart';

class NewsFormPage extends StatefulWidget {
  final News? news; // ✅ null = create, ada = edit

  const NewsFormPage({super.key, this.news});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _thumbnailController = TextEditingController();

  String _category = "";

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

    // ✅ EDIT MODE → isi form
    if (widget.news != null) {
      _titleController.text = widget.news!.title;
      _contentController.text = widget.news!.content;
      _thumbnailController.text = widget.news!.thumbnail ?? '';
      _category = widget.news!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isEdit = widget.news != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit News' : 'Add New News'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Judul Berita",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Judul tidak boleh kosong"
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Isi Berita",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Isi berita tidak boleh kosong"
                        : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _category.isNotEmpty ? _category : null,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(
                          cat[0].toUpperCase() + cat.substring(1),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty
                        ? "Kategori harus dipilih"
                        : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(
                  labelText: "URL Thumbnail (opsional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final url = isEdit
                        ? "http://localhost:8000/news/edit-news-ajax/${widget.news!.id}/"
                        : "http://localhost:8000/news/create-flutter/";

                    final response = await request.postJson(
                      url,
                      jsonEncode({
                        "title": _titleController.text,
                        "content": _contentController.text,
                        "category": _category,
                        "thumbnail": _thumbnailController.text,
                      }),
                    );

                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit
                                  ? "News updated successfully!"
                                  : "News created successfully!",
                            ),
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Something went wrong"),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
