import 'package:flutter/material.dart';
import 'package:dribbl_id/matches/models/match.dart';
import 'package:dribbl_id/matches/screens/match_detail.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    // Cek ketersediaan thumbnail
    final bool hasThumbnail = match.matchThumbnail != null && match.matchThumbnail!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchDetailPage(match: match)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E), // Background Gelap
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // --- 1. GAMBAR THUMBNAIL (Full Width) ---
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Match
                  Image.network(
                    hasThumbnail 
                        ? match.matchThumbnail! 
                        : "https://images.unsplash.com/photo-1546519638-68e109498ffc?q=80&w=1000", // Default Basket
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey[800]); // Placeholder jika error
                    },
                  ),
                  
                  // Gradient Hitam di Bawah Gambar (Agar teks Venue terbaca)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),

                  // Info Venue & Tanggal di atas Gambar
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.venue,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                          ),
                        ),
                        Text(
                          _formatDate(match.tipoffAt),
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Badge Status (Live/Finished)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _buildStatusBadge(match.status),
                  ),
                ],
              ),
            ),

            // --- 2. INFORMASI SKOR & NAMA TIM ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Team (Teks Kiri)
                  Expanded(
                    child: Text(
                      match.homeTeam,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15, // Ukuran font pas
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Skor (Tengah)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      "${match.homeScore} - ${match.awayScore}",
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Away Team (Teks Kanan)
                  Expanded(
                    child: Text(
                      match.awayTeam,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status.toLowerCase() == 'live' ? Colors.red : (status.toLowerCase() == 'finished' ? Colors.green : Colors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.9), borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} • ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
  }
}