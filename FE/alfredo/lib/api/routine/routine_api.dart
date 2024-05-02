import 'dart:convert';

import 'package:alfredo/models/routine/routine_model.dart';
import 'package:http/http.dart' as http;

class RoutineApi {
  static const String baseUrl = 'http://10.0.2.2:8080/api/routine';
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
    List<RoutineModel> routineInstances = [];
    final url = Uri.parse('$baseUrl/all');
    final response = await http.get(url, headers: _authHeaders(authToken));
    if (response.statusCode == 200) {
      final List<dynamic> routines = jsonDecode(response.body);
      for (var routine in routines) {
        routineInstances.add(RoutineModel.fromJson(routine));
      }
      return routineInstances;
    } else {
      throw Exception('Failed to load routines: ${response.statusCode}');
    }
  }
}
