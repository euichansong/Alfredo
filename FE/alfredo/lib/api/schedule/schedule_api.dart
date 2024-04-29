import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/schedule/schedule_model.dart';

class ScheduleApi {
  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<Schedule>> fetchSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Schedule.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<Schedule> getScheduleDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      print("Received data: $responseBody"); // 데이터 로깅
      return Schedule.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
          'Failed to load schedule detail. Status: ${response.statusCode}');
    }
  }

  Future<Schedule> createSchedule(Schedule schedule) async {
    String jsonBody = jsonEncode(schedule.toJson());
    print("Sending JSON to server: $jsonBody"); // JSON 데이터 로깅

    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    print('Response status: ${response.statusCode}');
    // 응답을 UTF-8로 디코드하여 출력
    String responseBody = utf8.decode(response.bodyBytes);
    if (response.statusCode == 201) {
      // 응답 본문을 JSON으로 디코드하고, Schedule 객체로 파싱
      return Schedule.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
          'Failed to create schedule. Status: ${response.statusCode}, Body: $responseBody');
    }
  }

  Future<Schedule> updateSchedule(int id, Schedule schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/detail/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 200) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update schedule');
    }
  }

  Future<void> deleteSchedule(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/detail/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete schedule');
    }
  }
}
