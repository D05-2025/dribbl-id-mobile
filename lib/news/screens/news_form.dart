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
  String _category = '';
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
      appBar: AppBar(
        title: Text(isEdit ? 'Edit News' : 'Add News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (v) => _title = v,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _content,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Content'),
                onChanged: (v) => _content = v,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (v) => _category = v,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _thumbnail,
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                onChanged: (v) => _thumbnail = v,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text(isEdit ? 'Update' : 'Save'),
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

                    if (context.mounted &&
                        response['status'] == 'success') {
                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
