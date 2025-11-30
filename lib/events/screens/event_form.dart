import 'package:flutter/material.dart';
import '../models/event.dart';

class EventFormPage extends StatefulWidget {
  final Function(Event) onSubmit;

  const EventFormPage({super.key, required this.onSubmit});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _formKey = GlobalKey<FormState>();

  int id = 0;
  String title = "";
  String description = "";
  DateTime date = DateTime.now();
  String time = "";
  String imageUrl = "";
  bool isPublic = true;
  String location = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "ID Event"),
                keyboardType: TextInputType.number,
                onChanged: (v) => id = int.tryParse(v) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                onChanged: (v) => title = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                onChanged: (v) => description = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Time"),
                onChanged: (v) => time = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Image URL"),
                onChanged: (v) => imageUrl = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Location"),
                onChanged: (v) => location = v,
              ),

              SwitchListTile(
                title: const Text("Public Event"),
                value: isPublic,
                onChanged: (v) => setState(() => isPublic = v),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  final newEvent = Event(
                    id: id,
                    title: title,
                    description: description,
                    date: date,
                    time: time,
                    imageUrl: imageUrl,
                    isPublic: isPublic,
                    location: location,
                  );

                  widget.onSubmit(newEvent);
                  Navigator.pop(context);
                },
                child: const Text("Simpan Event"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
