import 'package:flutter/material.dart';
import 'package:dribbl_id/events/services/event_service.dart';
import 'package:dribbl_id/events/widgets/event_card.dart';
import 'package:dribbl_id/events/screens/event_details.dart';

class EventListPage extends StatelessWidget {
  const EventListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = EventService();

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: FutureBuilder(
        future: service.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No Events Found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final events = snapshot.data!;

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
