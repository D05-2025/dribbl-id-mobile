// To parse this JSON data, do
//
//     final match = matchFromJson(jsonString);

import 'dart:convert';

List<Match> matchFromJson(String str) =>
    List<Match>.from(json.decode(str).map((x) => Match.fromJson(x)));

String matchToJson(List<Match> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Match {
  String uuid;
  String homeTeam;
  String awayTeam;
  DateTime tipoffAt;
  String venue;
  String status;
  int homeScore;
  int awayScore;

  Match({
    required this.uuid,
    required this.homeTeam,
    required this.awayTeam,
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
    "tipoff_at": tipoffAt.toIso8601String(),
    "venue": venue,
    "status": status,
    "home_score": homeScore,
    "away_score": awayScore,
  };
}
