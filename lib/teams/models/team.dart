// To parse this JSON data, do
//
//     final team = teamFromJson(jsonString);

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
    region: json["region"],
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
