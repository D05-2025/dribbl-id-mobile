import 'dart:convert';

List<Match> matchFromJson(String str) =>
    List<Match>.from(json.decode(str).map((x) => Match.fromJson(x)));

String matchToJson(List<Match> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Match {
  String uuid;
  String homeTeam;
  String awayTeam;
  // Field baru untuk gambar
  String? homeTeamLogo; 
  String? awayTeamLogo;
  String? matchThumbnail; 
  
  DateTime tipoffAt;
  String venue;
  String status;
  int homeScore;
  int awayScore;

  Match({
    required this.uuid,
    required this.homeTeam,
    required this.awayTeam,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.matchThumbnail,
    required this.tipoffAt,
    required this.venue,
    required this.status,
    required this.homeScore,
    required this.awayScore,
  });

  // Di file match.dart

factory Match.fromJson(Map<String, dynamic> json) {
    // ⚠️ PENTING: Gunakan 10.0.2.2 untuk Android Emulator
    // Jika pakai HP fisik, ganti dengan IP Laptop (misal 192.168.1.x)
    const String baseUrl = "http://10.0.2.2:8000"; 

    // Helper untuk memperbaiki URL
    String? getCorrectUrl(String? path) {
      if (path == null || path.isEmpty) return null;
      
      if (path.startsWith('http')) return path;
    
      return "$baseUrl$path";
    }

    return Match(
      uuid: json["uuid"],
      homeTeam: json["home_team"],
      awayTeam: json["away_team"],
      homeTeamLogo: json["home_team_logo"], 
      awayTeamLogo: json["away_team_logo"],
      
      // TERAPKAN LOGIC DI SINI
      matchThumbnail: getCorrectUrl(json["match_thumbnail"]), 
      
      tipoffAt: DateTime.parse(json["tipoff_at"]),
      venue: json["venue"],
      status: json["status"],
      homeScore: json["home_score"],
      awayScore: json["away_score"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "home_team": homeTeam,
    "away_team": awayTeam,
    "home_team_logo": homeTeamLogo,
    "away_team_logo": awayTeamLogo,
    "match_thumbnail": matchThumbnail,
    "tipoff_at": tipoffAt.toIso8601String(),
    "venue": venue,
    "status": status,
    "home_score": homeScore,
    "away_score": awayScore,
  };
}