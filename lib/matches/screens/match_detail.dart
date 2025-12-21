import 'package:flutter/material.dart';
import 'package:dribbl_id/matches/models/match.dart';

class MatchDetailPage extends StatelessWidget {
  final Match match;

  const MatchDetailPage({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300, 
                  child: Image.network(
                    match.matchThumbnail ?? "https://via.placeholder.com/400x300",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "${match.homeTeam} vs ${match.awayTeam}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.calendar_today, _formatFullDate(match.tipoffAt)),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, "Venue: ${match.venue}"),
                  
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      match.status,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                match.homeTeam,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.cyanAccent, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 18
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${match.homeScore}",
                                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 60, color: Colors.white24),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                match.awayTeam,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.redAccent, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 18
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${match.awayScore}",
                                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    label: const Text("Kembali ke Jadwal", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  String _formatFullDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}