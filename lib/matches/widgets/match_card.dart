import 'package:flutter/material.dart';
import 'package:dribbl_id/matches/models/match.dart';
import 'package:dribbl_id/matches/screens/match_detail.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    // Tentukan warna badge berdasarkan status
    bool isLive = match.status.toLowerCase() == 'live';
    bool isFinished = match.status.toLowerCase() == 'finished';
    
    Color badgeColor = isLive ? Colors.red : (isFinished ? Colors.green : Colors.grey);
    String badgeText = isLive ? "LIVE" : match.status;

    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail saat kartu ditekan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailPage(match: match),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200, // Tinggi kartu agar gambar terlihat jelas
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Gambar Thumbnail sebagai Background
          image: DecorationImage(
            image: NetworkImage(
              match.matchThumbnail ?? "https://via.placeholder.com/400x200?text=No+Image",
            ),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Fallback jika error (bisa diganti asset lokal)
            },
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          // Gradient Overlay supaya teks putih tetap terbaca di atas gambar
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3), // Agak terang di atas
                Colors.black.withOpacity(0.8), // Gelap di bawah untuk teks
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- Bagian Atas: Badge Status & Waktu ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badgeText.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Tanggal/Waktu kecil di pojok kanan atas
                  Text(
                    _formatShortDate(match.tipoffAt),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ],
              ),

              // --- Bagian Tengah/Bawah: Info Tim & Skor ---
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Home Team
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              match.homeTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${match.homeScore}",
                              style: const TextStyle(
                                color: Colors.cyanAccent, // Warna skor menonjol
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // VS Label
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "VS",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Away Team
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              match.awayTeam,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${match.awayScore}",
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Lokasi Kecil di Bawah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          match.venue,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    // Ex: Oct 26, 19:30
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}