import 'dart:convert';
import 'package:alfredo/provider/user/future_provider.dart';
import 'package:http/http.dart' as http;
import '../../models/schedule/schedule_model.dart';

class ScheduleApi {
  final String baseUrl = 'http://10.0.2.2:8080';

  ScheduleApi();

  // 헤더에 토큰이 필요 없는 경우
  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=UTF-8',
      };

  // 헤더에 토큰이 필요한 경우
  Map<String, String> _authHeaders(String authToken) => {
        ..._headers,
        'Authorization': 'Bearer $authToken',
      };

  // 사용자가 작성한 전체 일정 조회
  Future<List<Schedule>> fetchSchedules(String authToken) async {
    final response = await http.get(Uri.parse('$baseUrl/list'),
        headers: _authHeaders(authToken));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Schedule.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<Schedule> getScheduleDetail(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/detail/$id'), headers: _headers);
    if (response.statusCode == 200) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load schedule detail. Status: ${response.statusCode}');
    }
  }

  // 일정 생성
  Future<Schedule> createSchedule(Schedule schedule, String authToken) async {
    final response = await http.post(Uri.parse('$baseUrl/save'),
        headers: _authHeaders(authToken), body: jsonEncode(schedule.toJson()));
    if (response.statusCode == 201) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create schedule');
    }
  }

  // Update and delete do not require authorization in this setup
  Future<void> updateSchedule(int id, Schedule schedule) async {
    String jsonString = jsonEncode(schedule.toJson());
    print('Sending JSON body: $jsonString');

    final response = await http.patch(
      Uri.parse('$baseUrl/detail/$id'),
      headers: _headers,
      body: jsonString,
    );

    if (response.statusCode == 200) {
      print('Update successful. Status: ${response.statusCode}');
    } else {
      print('Failed to update. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update schedule');
    }
  }

  Future<void> deleteSchedule(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/detail/$id'), headers: _headers);

    // 성공적인 응답으로 200 OK와 204 No Content를 모두 처리
    if (response.statusCode != 200 && response.statusCode != 204) {
      print('Failed to delete. Status: ${response.statusCode}');
      throw Exception(
          'Failed to delete schedule. Status: ${response.statusCode}');
    }
  }
}
