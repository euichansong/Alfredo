import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final attendanceProvider = Provider((ref) => AttendanceService());

class AttendanceService {
  static final String baseUrl = dotenv.get("ATTENDANCE_API_URL");
  Future<void> checkAttendance(String? authToken) async {
    print("출석provider 실행중");
    final url = Uri.parse('$baseUrl/check');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to check attendance');
    }
  }
}
