import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/event.dart';
import 'event_form.dart';
import '../widgets/event_card.dart';
import 'event_details.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  Future<List<Event>> fetchEvents(CookieRequest request) async {
    final response = await request.get("http://localhost:8000/events/json/");

    List<Event> events = [];
    for (var e in response) {
      events.add(Event.fromJson(e));
    }
    return events;
  }

  Future<void> deleteEvent(CookieRequest request, int eventId) async {
    try {
      final response = await request.post(
        "http://localhost:8000/events/$eventId/delete/",
        {},
      );

      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Event berhasil dihapus!")),
          );
          setState(() {}); // Refresh list
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void showDeleteConfirmation(CookieRequest request, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event"),
        content: Text("Yakin ingin menghapus event '${event.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEvent(request, event.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventFormPage()),
          );

          if (result == true) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: fetchEvents(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No events found"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final event = snapshot.data![index];
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
                onEdit: () {
                  // Navigate to edit page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventFormPage(event: event),
                    ),
                  ).then((result) {
                    if (result == true) setState(() {});
                  });
                },
                onDelete: () {
                  showDeleteConfirmation(request, event);
                },
              );
            },
          );
        },
      ),
    );
  }
}