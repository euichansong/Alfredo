import 'package:http/http.dart' as http;
import 'dart:convert';

class TokenApi {
  static Future<void> sendTokenToServer(String idToken) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/users/login');
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
