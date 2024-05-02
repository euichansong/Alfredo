import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv 패키지 추가

class TokenApi {
  static final String _baseUrl = dotenv.env['USER_API_URL']!;

  static Future<void> sendTokenToServer(String idToken) async {
    var url = Uri.parse('$_baseUrl/login');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        print('Token sent successfully $idToken');
      } else {
        print('Failed to send token: ${response.body}');
      }
    } catch (e) {
      print('Error sending token: $e');
    }
  }
}
