// File: lib/teams/models/team.dart
import 'dart:convert';

List<Team> teamFromJson(String str) =>
    List<Team>.from(json.decode(str).map((x) => Team.fromJson(x)));

String teamToJson(List<Team> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Team {
  String name;
  String logo;
  String region;
  DateTime founded;
  String description;

  Team({
    required this.name,
    required this.logo,
    required this.region,
    required this.founded,
    required this.description,
  });

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    name: json["name"],
    logo: json["logo"],
    // Handle jika region null atau tidak ada di JSON
    region: json["region"] ?? "Unknown", 
    founded: DateTime.parse(json["founded"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "logo": logo,
    "region": region,
    "founded":
        "${founded.year.toString().padLeft(4, '0')}-${founded.month.toString().padLeft(2, '0')}-${founded.day.toString().padLeft(2, '0')}",
    "description": description,
  };
}