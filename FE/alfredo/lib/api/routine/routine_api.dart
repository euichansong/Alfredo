import 'dart:convert';

import 'package:alfredo/models/routine/routine_model.dart';
import 'package:http/http.dart' as http;

class RoutineApi {
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<List<RoutineModel>> getAllRoutines() async {
    List<RoutineModel> routineInstances = [];
    final url = Uri.parse('$baseUrl/routine/all');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> routines = jsonDecode(response.body);
      // print(routines);
      for (var routine in routines) {
        routineInstances.add(RoutineModel.fromJson(routine));
      }
      return routineInstances;
    } else {
      throw Exception('Failed to load routines: ${response.statusCode}');
    }
  }
}
