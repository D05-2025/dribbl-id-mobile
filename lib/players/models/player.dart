// To parse this JSON data, do
//
//     final player = playerFromJson(jsonString);

import 'dart:convert';

List<Player> playerFromJson(String str) =>
    List<Player>.from(json.decode(str).map((x) => Player.fromJson(x)));

String playerToJson(List<Player> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Player {
  String name;
  String position;
  String team;
  double pointsPerGame;
  double assistsPerGame;
  double reboundsPerGame;

  Player({
    required this.name,
    required this.position,
    required this.team,
    required this.pointsPerGame,
    required this.assistsPerGame,
    required this.reboundsPerGame,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    name: json["name"],
    position: json["position"],
    team: json["team"],
    pointsPerGame: json["points_per_game"],
    assistsPerGame: json["assists_per_game"],
    reboundsPerGame: json["rebounds_per_game"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "position": position,
    "team": team,
    "points_per_game": pointsPerGame,
    "assists_per_game": assistsPerGame,
    "rebounds_per_game": reboundsPerGame,
  };
}
