import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmApi {
  final String baseUrl = dotenv.get("ALARM_API_URL");

  /// 토큰과 일정 정보를 서버로 전송합니다.
  Future<void> sendTokenAndScheduleData(
      String token, String title, String body) async {
    var url = Uri.parse('$baseUrl/send');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'targetToken': token,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      print("Data successfully sent to the server");
    } else {
      print(
          "Failed to send data to server: ${response.statusCode} - ${response.body}");
    }
  }

  /// 시작 날짜와 시간을 문자열로 포매팅합니다.
  String formatScheduleDateTime(DateTime startDate, TimeOfDay? startTime) {
    final dateStr = DateFormat('yyyy-MM-dd').format(startDate);
    final timeStr = startTime != null
        ? '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'
        : 'All Day';
    return '$dateStr $timeStr';
  }

  /// 문자열로부터 TimeOfDay를 생성합니다.
  static TimeOfDay _timeFromString(String timeStr) {
    final timeParts = timeStr.split(':').map(int.parse).toList();
    return TimeOfDay(hour: timeParts[0], minute: timeParts[1]);
  }
}
