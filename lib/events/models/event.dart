// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

List<Event> eventFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Event {
  int id;
  String title;
  String description;
  DateTime date;
  String time;
  String imageUrl;
  bool isPublic;
  String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.isPublic,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    imageUrl: json["image_url"],
    isPublic: json["is_public"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "image_url": imageUrl,
    "is_public": isPublic,
    "location": location,
  };
}
