import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _location = "";
  String _time = "";
  String _imageUrl = "";
  DateTime _date = DateTime.now();
  bool _isPublic = true;

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (selected != null) {
      setState(() => _date = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Tambah Event")),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Judul Event",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (v) => _title = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Judul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Deskripsi Event",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (v) => _description = v,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Deskripsi tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),

              // === Location ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Lokasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (v) => _location = v,
                ),
              ),

              // === Time ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Waktu (contoh: 18:00 WIB)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (v) => _time = v,
                ),
              ),

              // === Image URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (v) => _imageUrl = v,
                ),
              ),

              // === Date Picker ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Tanggal: ${_date.toLocal()}".split(" ")[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),
              ),

              // === Public Switch ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Public Event"),
                  value: _isPublic,
                  onChanged: (v) => setState(() => _isPublic = v),
                ),
              ),

              // === Submit Button ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await request.postJson(
                          "http://localhost:8000/events/create-flutter/",
                          jsonEncode({
                            "title": _title,
                            "description": _description,
                            "location": _location,
                            "date": _date.toIso8601String(),
                            "time": _time,
                            "image_url": _imageUrl,
                            "is_public": _isPublic,
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Event berhasil disimpan!")),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Gagal menyimpan event.")),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Simpan Event",
                      style: TextStyle(color: Colors.white),
                    ),
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