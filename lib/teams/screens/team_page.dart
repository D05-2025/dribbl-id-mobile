import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:dribbl_id/teams/models/team.dart';
import 'package:dribbl_id/teams/widgets/team_card.dart';
import 'package:dribbl_id/teams/screens/team_detail.dart';
import 'package:dribbl_id/teams/screens/team_form.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  String _searchQuery = "";
  String _selectedRegion = "All Regions";
  
  late Future<List<Team>> _futureTeams;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _futureTeams = fetchTeams(request);
  }

  Future<List<Team>> fetchTeams(CookieRequest request) async {
    // Ganti URL sesuai endpoint kamu
    final response = await request.get('http://localhost:8000/teams/json/');
    List<Team> listTeams = [];
    for (var d in response) {
      if (d != null) {
        listTeams.add(Team.fromJson(d));
      }
    }
    return listTeams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("All Teams", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        // (Opsional) Tombol di atas bisa dihapus jika ingin pakai tombol bawah saja
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.add_box_outlined, color: Colors.blueAccent),
              tooltip: "Add New Team",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamFormPage()),
                ).then((_) {
                  setState(() {
                    final request = context.read<CookieRequest>();
                    _futureTeams = fetchTeams(request);
                  });
                });
              },
            ),
          ),
        ],
      ),
      // --- TOMBOL ADD (Floating Action Button) ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent, 
        tooltip: 'Add Team',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeamFormPage()),
          ).then((_) {
            // Refresh data saat kembali
            setState(() {
              final request = context.read<CookieRequest>();
              _futureTeams = fetchTeams(request);
            });
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // -------------------------------------------
      body: FutureBuilder(
        future: _futureTeams,
        builder: (context, AsyncSnapshot<List<Team>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No teams found.", style: TextStyle(color: Colors.white)));
          }

          final allTeams = snapshot.data!;
          Set<String> regions = {"All Regions"};
          regions.addAll(allTeams.map((e) => e.region));

          final filteredTeams = allTeams.where((team) {
            final matchesName = team.name.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesRegion = _selectedRegion == "All Regions" || team.region == _selectedRegion;
            return matchesName && matchesRegion;
          }).toList();

          return Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Column(
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search by name...",
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        filled: true,
                        fillColor: const Color(0xFF1C1C1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: regions.contains(_selectedRegion) ? _selectedRegion : "All Regions",
                          dropdownColor: const Color(0xFF1C1C1E),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRegion = newValue!;
                            });
                          },
                          items: regions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Grid Teams
              Expanded(
                child: filteredTeams.isEmpty
                    ? const Center(child: Text("No teams match your filter.", style: TextStyle(color: Colors.grey)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredTeams.length,
                        itemBuilder: (context, index) {
                          final team = filteredTeams[index];
                          return TeamCard(
                            team: team,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeamDetailPage(team: team),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}