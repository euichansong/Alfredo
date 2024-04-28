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
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load schedule detail');
    }
  }

  Future<Schedule> createSchedule(Schedule schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(schedule.toJson()),
    );

    if (response.statusCode == 201) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create schedule');
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
