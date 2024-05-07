import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../models/routine/routine_model.dart'; //g.dart로 해야 되나?
import '../../provider/user/future_provider.dart';

// RoutineController를 위한 Provider 정의
final routineProvider = FutureProvider.autoDispose<List<Routine>>((ref) async {
  final idToken = await ref.watch(authManagerProvider.future);
  final String baseUrl = dotenv.env['ROUTINE_API_URL']!;
  var url = Uri.parse('$baseUrl/all');
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((e) => Routine.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load routines');
  }
});
