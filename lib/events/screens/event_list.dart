import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/event.dart';
import '../widgets/event_card.dart';
import 'event_details.dart';
import 'event_form.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  void openDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsPage(event: event),
      ),
    );
  }

  void navigateToEdit(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventFormPage(),
      ),
    ).then((value) {
      if (value == true) setState(() {});
    });
  }

  void deleteEvent(int id) async {
    final request = context.read<CookieRequest>();

    try {
      // 🔥 Kirim ID lewat JSON body, bukan URL parameter
      final response = await request.postJson(
        "http://localhost:8000/events/delete-flutter/",
        jsonEncode({"id": id}),
      );

      if (!mounted) return;

      if (response is Map) {
        if (response['status'] == 'success' || response['message']?.contains('berhasil') == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Event berhasil dihapus!"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {}); // refresh list
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? response['error'] ?? "Gagal menghapus event"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Jika response bukan Map, anggap sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event berhasil dihapus!"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      // 🔥 Parse error message
      String errorMsg = "Error: $e";
      if (e.toString().contains('403')) {
        errorMsg = "Akses ditolak! Hanya admin yang dapat menghapus event.";
      } else if (e.toString().contains('404')) {
        errorMsg = "Event tidak ditemukan.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event"),
        content: Text(
          "Yakin ingin menghapus event '${event.title}'?\n\nTindakan ini tidak dapat dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEvent(event.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<List<Event>> fetchEvents(CookieRequest request) async {
    final response = await request.get("http://localhost:8000/events/json/");
    return response.map<Event>((e) => Event.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isAdmin = request.jsonData["role"] == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Event List"),
        actions: [
          if (isAdmin)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "ADMIN",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EventFormPage(),
            ),
          ).then((value) {
            if (value == true) setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      body: FutureBuilder(
        future: fetchEvents(request),
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Tidak ada event ditemukan.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final event = snapshot.data![index];

              return EventCard(
                event: event,
                onTap: () => openDetail(event),
                onEdit: isAdmin ? () => navigateToEdit(event) : null,
                onDelete: isAdmin ? () => showDeleteConfirmation(event) : null,
              );
            },
          );
        },
      ),
    );
  }
}