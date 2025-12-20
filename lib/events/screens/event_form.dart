import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/event.dart';

class EventFormPage extends StatefulWidget {
  final Event? event;   // null → create, not null → edit

  const EventFormPage({super.key, this.event});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk prefill
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _timeController;
  late TextEditingController _imageUrlController;

  DateTime _date = DateTime.now();
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();

    final e = widget.event;

    _titleController = TextEditingController(text: e?.title ?? "");
    _descriptionController = TextEditingController(text: e?.description ?? "");
    _locationController = TextEditingController(text: e?.location ?? "");
    _timeController = TextEditingController(text: e?.time ?? "");
    _imageUrlController = TextEditingController(text: e?.imageUrl ?? "");

    _date = e?.date ?? DateTime.now();
    _isPublic = e?.isPublic ?? true;
  }

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
        title: Center(
          child: Text(widget.event == null ? "Tambah Event" : "Edit Event"),
        ),
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
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Judul Event",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Deskripsi Event",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: "Lokasi",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // === Time ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _timeController,
                  decoration: InputDecoration(
                    labelText: "Waktu (contoh: 18:00 WIB)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),

              // === Image URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(
                    labelText: "Image URL",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
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
                      backgroundColor:
                      MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final body = {
                          "title": _titleController.text,
                          "description": _descriptionController.text,
                          "location": _locationController.text,
                          "date": _date.toIso8601String(),
                          "time": _timeController.text,
                          "image_url": _imageUrlController.text,
                          "is_public": _isPublic,
                        };

                        late final response;

                        // === UPDATE MODE ===
                        if (widget.event != null) {
                          response = await request.postJson(
                            "http://localhost:8000/events/edit-flutter/",
                            jsonEncode({
                              "id": widget.event!.id,
                              ...body,
                            }),
                          );

                          // === CREATE MODE ===
                        } else {
                          response = await request.postJson(
                            "http://localhost:8000/events/create-flutter/",
                            jsonEncode(body),
                          );
                        }

                        if (!context.mounted) return;

                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.event == null
                                    ? "Event berhasil dibuat!"
                                    : "Event berhasil diperbarui!",
                              ),
                            ),
                          );
                          Navigator.pop(context, true);  // ← kirim true ke halaman sebelumnya
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Gagal menyimpan event.")),
                          );
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