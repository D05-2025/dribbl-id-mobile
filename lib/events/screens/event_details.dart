import 'package:flutter/material.dart';
import 'package:dribbl_id/events/models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    // Format: 2025-10-25 (ISO style) — gampang dan jelas
    return "${d.year}-${_twoDigits(d.month)}-${_twoDigits(d.day)}";
  }

  String _formatTime(DateTime dt) {
    final d = dt.toLocal();
    return "${_twoDigits(d.hour)}:${_twoDigits(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    // Determine time string:
    final String timeText;
    if (event.time != null && event.time!.trim().isNotEmpty) {
      timeText = event.time!;
    } else {
      timeText = _formatTime(event.date);
    }

    final String dateText = _formatDate(event.date);
    final String locationText = (event.location == null || event.location!.trim().isEmpty)
        ? "Lokasi belum ditentukan"
        : event.location!;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              child: Image.network(
                event.imageUrl!,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade900,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, size: 48, color: Colors.white30),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                // Row: date & time chips
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today_outlined,
                      label: dateText,
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: Icons.access_time,
                      label: timeText,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locationText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Description header
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Description body
                Text(
                  (event.description == null || event.description!.trim().isEmpty)
                      ? "Tidak ada deskripsi."
                      : event.description!,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),

                const SizedBox(height: 22),

                // Optional actions (edit/join) — contoh tombol
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // contoh action: buka peta / share / register
                      },
                      icon: const Icon(Icons.map_outlined),
                      label: const Text("Buka di Peta"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        // contoh action: share / daftar
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Bagikan"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
