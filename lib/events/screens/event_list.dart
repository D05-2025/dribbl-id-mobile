import 'package:flutter/material.dart';
import 'package:dribbl_id/events/services/event_service.dart';
import 'package:dribbl_id/events/widgets/event_card.dart';
import 'package:dribbl_id/events/screens/event_details.dart';
import 'package:dribbl_id/events/screens/event_form.dart'; // sesuaikan path kalau perlu
import 'package:dribbl_id/events/models/event.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final EventService service = EventService();

  /// Gunakan ini sebagai cache sementara agar tidak memanggil API berulang
  Future<List<Event>>? _futureEvents;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _futureEvents = service.getEvents();
    setState(() {}); // trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // buka form, tunggu hasil. form akan return `true` jika berhasil simpan
          final result = await Navigator.push<bool?>(
            context,
            MaterialPageRoute(
              builder: (_) => EventFormPage(
                onSubmit: (event) async {
                  // pastikan addEvent mengembalikan Future jika melakukan I/O
                  await service.addEvent(event);
                },
              ),
            ),
          );

          // kalau berhasil (true), reload events
          if (result == true) {
            _loadEvents();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                "No Events Found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return EventCard(
                event: event,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsPage(event: event),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
