import 'package:flutter/material.dart';
import 'package:dribbl_id/events/models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: ListView(
        children: [
          if (event.imageUrl.isNotEmpty)
            Image.network(
              event.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${event.date.toLocal()}".split(" ")[0],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
