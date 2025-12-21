import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dribbl_id/matches/models/match.dart';
import 'package:dribbl_id/matches/widgets/match_card.dart';
import 'package:dribbl_id/matches/screens/match_form.dart';

class MatchSchedulePage extends StatefulWidget {
  const MatchSchedulePage({super.key});

  @override
  State<MatchSchedulePage> createState() => _MatchSchedulePageState();
}

class _MatchSchedulePageState extends State<MatchSchedulePage> {
  String _selectedTab = 'Live';

  Future<List<Match>> fetchMatches(CookieRequest request) async {
    // Sesuaikan URL
    final response = await request.get(
      'https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/matches/json/',
    );
    List<Match> listMatch = [];
    for (var d in response) {
      if (d != null) {
        listMatch.add(Match.fromJson(d));
      }
    }
    return listMatch;
  }

  List<Match> _filterMatches(List<Match> allMatches) {
    if (_selectedTab == 'Live') {
      return allMatches.where((m) => m.status.toLowerCase() == 'live').toList();
    } else if (_selectedTab == 'Scheduled') {
      return allMatches
          .where(
            (m) =>
                m.status.toLowerCase() == 'upcoming' ||
                m.status.toLowerCase() == 'scheduled',
          )
          .toList();
    } else {
      return allMatches
          .where((m) => m.status.toLowerCase() == 'finished')
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        tooltip: 'Add Match',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatchFormPage()),
          ).then((_) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Match Schedule",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.cyanAccent.withOpacity(0.6),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildTabItem("Live"),
                  _buildTabItem("Scheduled"),
                  _buildTabItem("Finished"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder(
                future: fetchMatches(request),
                builder: (context, AsyncSnapshot<List<Match>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No matches available",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    final filteredMatches = _filterMatches(snapshot.data!);

                    if (filteredMatches.isEmpty) {
                      return Center(
                        child: Text(
                          "No $_selectedTab matches.",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredMatches.length,
                      itemBuilder: (_, index) {
                        return MatchCard(match: filteredMatches[index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title) {
    bool isActive = _selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.cyanAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

//tes
