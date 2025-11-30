import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dribbl_id/events/models/event.dart';

class EventService {
  final String baseUrl = "http://localhost:8000/events/json/";

  Future<List<Event>> getEvents() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load events (${response.statusCode})");
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));

    return List<Event>.from(
      data.map((json) => Event.fromJson(json)),
    );
  }
}
