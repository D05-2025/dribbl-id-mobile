import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/event.dart';

class EventFormPage extends StatefulWidget {
  final Event? event; // Null = create mode, not null = edit mode

  const EventFormPage({super.key, this.event});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  late String _location;
  late String _time;
  late String _imageUrl;
  late DateTime _date;
  late bool _isPublic;

  @override
  void initState() {
    super.initState();
    // Initialize with existing event data if in edit mode
    if (widget.event != null) {
      _title = widget.event!.title;
      _description = widget.event!.description;
      _location = widget.event!.location;
      _time = widget.event!.time;
      _imageUrl = widget.event!.imageUrl;
      _date = widget.event!.date;
      _isPublic = widget.event!.isPublic;
    } else {
      _title = "";
      _description = "";
      _location = "";
      _time = "";
      _imageUrl = "";
      _date = DateTime.now();
      _isPublic = true;
    }
  }

  bool get isEditMode => widget.event != null;

  Future pickDate() async {
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
        title: Text(isEditMode ? "Edit Event" : "Tambah Event"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // === Title ===
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: "Judul Event",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (v) => _title = v,
                validator: (v) =>
                (v == null || v.isEmpty) ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // === Description ===
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                maxLines: 4,
                onChanged: (v) => _description = v,
                validator: (v) =>
                (v == null || v.isEmpty) ? "Deskripsi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),

              // === Location ===
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(
                  labelText: "Lokasi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (v) => _location = v,
              ),
              const SizedBox(height: 12),

              // === Time ===
              TextFormField(
                initialValue: _time,
                decoration: InputDecoration(
                  labelText: "Waktu (contoh: 18:00 WIB)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (v) => _time = v,
              ),
              const SizedBox(height: 12),

              // === Image URL ===
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onChanged: (v) => _imageUrl = v,
              ),
              const SizedBox(height: 12),

              // === Date Picker ===
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal: ${_date.toLocal()}".split(" ")[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: pickDate,
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // === Public Switch ===
              SwitchListTile(
                title: const Text("Public Event"),
                value: _isPublic,
                onChanged: (v) => setState(() => _isPublic = v),
              ),
              const SizedBox(height: 20),

              // === Submit ===
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final url = isEditMode
                        ? "http://localhost:8000/events/${widget.event?.id}/edit/"
                        : "http://localhost:8000/events/create-flutter/";

                    final response = await request.postJson(
                      url,
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

                    if (!mounted) return;

                    if (response["status"] == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isEditMode
                                ? "Event berhasil diupdate!"
                                : "Event berhasil disimpan!")),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isEditMode
                                ? "Gagal mengupdate event."
                                : "Gagal menyimpan event.")),
                      );
                    }
                  }
                },
                child: Text(
                  isEditMode ? "Update Event" : "Simpan Event",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}