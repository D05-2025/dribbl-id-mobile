import 'package:flutter/material.dart';
import 'package:dribbl_id/players/models/player.dart';
import 'package:dribbl_id/players/screens/player_details.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailPage(player: player),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: const BoxDecoration(
          color: Color(0xFF1F2937), // Matches table background
          border: Border(
            bottom: BorderSide(color: Color(0xFF374151)), // Darker separator
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                player.name,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                player.team,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                player.position,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${player.pointsPerGame}.0", 
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${player.assistsPerGame}.0", 
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.right,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${player.reboundsPerGame}.0", 
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
