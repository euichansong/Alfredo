import 'dart:convert';

import 'package:alfredo/models/routine/routine_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RoutineApi {
  static final String baseUrl = dotenv.get("ROUTINE_API_URL");
  // static const String baseUrl = 'http://127.0.0.1:8080';
  RoutineApi();

// 헤더에 토큰이 필요 없는 경우
  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=UTF-8',
      };

  // 헤더에 토큰이 필요한 경우
  Map<String, String> _authHeaders(String authToken) => {
        ..._headers,
        'Authorization': 'Bearer $authToken',
      };

  //로그인한 유저의 전체 일정 조회
  Future<List<RoutineModel>> getAllRoutines(String authToken) async {
    final url = Uri.parse('$baseUrl/all');
    final response = await http.get(url, headers: _authHeaders(authToken));

    if (response.statusCode == 200) {
      final List<dynamic> routines = jsonDecode(response.body);
      return routines.map((routine) => RoutineModel.fromJson(routine)).toList();
    } else {
      throw Exception('Failed to load routines: ${response.statusCode}');
    }
  }

  //로그인한 유저의 일정 생성
  Future<void> createRoutine(
      String authToken,
      String routineTitle,
      String startTime,
      List<String> days,
      String alarmSound,
      String memo) async {
    final url = Uri.parse(baseUrl);

    final body = jsonEncode({
      "routineTitle": routineTitle,
      "startTime": startTime,
      "days": days,
      "alarmSound": alarmSound,
      "memo": memo,
    });

    final response =
        await http.post(url, headers: _authHeaders(authToken), body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create routine: ${response.statusCode}');
    }
  }
}
