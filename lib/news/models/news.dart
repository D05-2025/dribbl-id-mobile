// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<News> newsFromJson(String str) =>
    List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

String newsToJson(List<News> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class News {
  String id;
  String userId;
  String title;
  String content;
  String category;
  String thumbnail;
  DateTime createdAt;

  News({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.category,
    required this.thumbnail,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    content: json["content"],
    category: json["category"],
    thumbnail: json["thumbnail"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "content": content,
    "category": category,
    "thumbnail": thumbnail,
    "created_at": createdAt.toIso8601String(),
  };
}
