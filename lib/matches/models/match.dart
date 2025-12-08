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

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    uuid: json["uuid"],
    homeTeam: json["home_team"],
    awayTeam: json["away_team"],
    // Ambil data logo/thumbnail jika ada di JSON, jika tidak null
    homeTeamLogo: json["home_team_logo"], 
    awayTeamLogo: json["away_team_logo"],
    matchThumbnail: json["match_thumbnail"],
    
    tipoffAt: DateTime.parse(json["tipoff_at"]),
    venue: json["venue"],
    status: json["status"],
    homeScore: json["home_score"],
    awayScore: json["away_score"],
  );

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