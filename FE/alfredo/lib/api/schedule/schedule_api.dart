import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/schedule/schedule_model.dart';

class ScheduleApi {
  final String baseUrl = 'http://your-server-address/api';

  Future<List<Schedule>> fetchSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/schedules'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Schedule.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<Schedule> createSchedule(Schedule schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedules'),
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
      Uri.parse('$baseUrl/schedules/$id'),
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
      Uri.parse('$baseUrl/schedules/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete schedule');
    }
  }
}
