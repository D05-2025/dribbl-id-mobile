import 'package:flutter/material.dart';
import 'package:dribbl_id/players/models/player.dart';
import 'package:dribbl_id/players/widgets/player_card.dart';
import 'package:dribbl_id/players/screens/player_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  Future<List<Player>> fetchPlayers(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/players/json/');
    
    var data = response;
    
    List<Player> listPlayer = [];
    for (var d in data) {
      if (d != null) {
        listPlayer.add(Player.fromJson(d));
      }
    }
    return listPlayer;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Statistics'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Back Button Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text("Back"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF374151), // Dark button
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
          // Table Container
          Expanded(
            child: Container(
             margin: const EdgeInsets.symmetric(horizontal: 16.0),
             decoration: BoxDecoration(
               color: const Color(0xFF1F2937), // Dark grey background for table
               borderRadius: BorderRadius.circular(8.0),
               border: Border.all(color: const Color(0xFF374151)),
             ),
             child: Column(
               children: [
                 // Table Header
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                   decoration: const BoxDecoration(
                     color: Color(0xFF111827), // Darker header background
                     borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                     border: Border(bottom: BorderSide(color: Color(0xFF374151))),
                   ),
                   child: Row(
                     children: [
                       Expanded(flex: 3, child: Text("NAME", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11))),
                       Expanded(flex: 1, child: Text("TEAM", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11))),
                       Expanded(flex: 1, child: Text("POSITION", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11))),
                       Expanded(flex: 1, child: Text("PTS", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                       Expanded(flex: 1, child: Text("AST", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                       Expanded(flex: 1, child: Text("REB", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.right)),
                     ],
                   ),
                 ),
                 Expanded(
                   child: FutureBuilder(
                     future: fetchPlayers(request),
                     builder: (context, AsyncSnapshot snapshot) {
                       if (snapshot.data == null) {
                         return const Center(child: CircularProgressIndicator());
                       } else {
                         if (!snapshot.hasData) {
                           return const Center( // Center the no data text properly
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text(
                                   "No player data available.",
                                   style: TextStyle(color: Colors.white, fontSize: 16),
                                 ),
                               ],
                             ),
                           );
                         } else {
                           return ListView.builder(
                             itemCount: snapshot.data!.length,
                             itemBuilder: (_, index) {
                               return PlayerCard(player: snapshot.data![index]);
                             },
                           );
                         }
                       }
                     },
                   ),
                 ),
               ],
             ),
            ),
          ),
          const SizedBox(height: 20), // Bottom spacing
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerFormPage()),
          );
          setState(() {});
        },
        backgroundColor: Colors.orange[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
