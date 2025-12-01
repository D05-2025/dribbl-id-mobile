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

  Future pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selected != null) {
      setState(() => date = selected);
    }
  }

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

              // Title
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                onChanged: (v) => title = v,
              ),

              // Description
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                onChanged: (v) => description = v,
              ),

              // Time (string)
              TextFormField(
                decoration: const InputDecoration(labelText: "Time (e.g. 18:30 WIB)"),
                onChanged: (v) => time = v,
              ),

              // Image URL
              TextFormField(
                decoration: const InputDecoration(labelText: "Image URL"),
                onChanged: (v) => imageUrl = v,
              ),

              // Location
              TextFormField(
                decoration: const InputDecoration(labelText: "Location"),
                onChanged: (v) => location = v,
              ),

              const SizedBox(height: 16),

              // Date Picker Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tanggal: ${date.toLocal()}".split(" ")[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: pickDate,
                    child: const Text("Pilih Tanggal"),
                  )
                ],
              ),

              const SizedBox(height: 10),

              // Switch isPublic
              SwitchListTile(
                title: const Text("Public Event"),
                value: isPublic,
                onChanged: (v) => setState(() => isPublic = v),
              ),

              const SizedBox(height: 20),

              // SUBMIT BUTTON
              ElevatedButton(
                onPressed: () async {
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

                  final result = widget.onSubmit(newEvent);
                  if (result is Future) await result;

                  Navigator.pop(context, true); // penting!
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
