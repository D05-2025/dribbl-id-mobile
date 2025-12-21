import 'package:flutter/material.dart';
import 'package:dribbl_id/events/models/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    return "${d.year}-${_twoDigits(d.month)}-${_twoDigits(d.day)}";
  }

  String _formatTime(DateTime dt) {
    final d = dt.toLocal();
    return "${_twoDigits(d.hour)}:${_twoDigits(d.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Event", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Jika layar sangat lebar (Desktop), tetap gunakan side-by-side
          if (constraints.maxWidth > 1100) {
            return _buildDesktopLayout();
          } else {
            // Untuk iPad dan iPhone, gunakan layout vertikal yang sama
            return _buildUnifiedMobileLayout(context);
          }
        },
      ),
    );
  }

  // ================= UNIFIED LAYOUT (IPHONE & IPAD) =================
  Widget _buildUnifiedMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // ConstrainedBox ini yang menjaga agar di iPad kontennya tidak melar ke samping
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kotak Foto (Sama seperti iPhone)
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: _buildEventImage(),
                ),
              ),
              const SizedBox(height: 32),
              _buildMainHeader(),
              const SizedBox(height: 32),
              _buildSplitInfoGrid(),
              const SizedBox(height: 48),
              _buildActionButtons(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ================= DESKTOP LAYOUT (Hanya untuk monitor besar) =================
  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(aspectRatio: 1, child: _buildEventImage()),
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainHeader(),
                  const SizedBox(height: 32),
                  _buildSplitInfoGrid(),
                  const SizedBox(height: 40),
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REUSABLE COMPONENTS =================

  Widget _buildEventImage() {
    return Image.network(
      event.imageUrl ?? '',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade900,
        child: const Icon(Icons.broken_image, color: Colors.white30, size: 48),
      ),
    );
  }

  Widget _buildMainHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          event.description ?? "Saksikan pertandingan seru Fasilkom melawan FT",
          style: TextStyle(color: Colors.grey.shade400, fontSize: 16, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildSplitInfoGrid() {
    return Column(
      children: [
        _infoTile(Icons.calendar_today_rounded, "Tanggal", _formatDate(event.date), Colors.blueAccent),
        const SizedBox(height: 16),
        _infoTile(Icons.access_time_rounded, "Jam", event.time ?? _formatTime(event.date), Colors.orangeAccent),
        const SizedBox(height: 16),
        _infoTile(Icons.location_on_outlined, "Lokasi", event.location ?? "Lokasi belum ditentukan", Colors.redAccent),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String content, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            Text(content, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("Buka di Peta", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}