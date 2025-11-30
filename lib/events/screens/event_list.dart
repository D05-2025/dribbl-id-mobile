import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import 'event_details.dart';

class EventListPage extends StatelessWidget {
  final List<Event> events;

  const EventListPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: events.isEmpty
          ? const Center(child: Text("Belum ada event"))
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EventDetailsPage(event: events[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
