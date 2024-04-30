import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/user/future_provider.dart';
import '../../models/user/user_update_dto.dart';

class UserApi {
  static const String _baseUrl = "http://10.0.2.2:8080/api/users";

  Future<User> getUserInfo(String idToken) async {
    if (!idToken.contains('.') || idToken.split('.').length != 3) {
      print('ID 토큰의 형식이 올바른 JWT 형식이 아닌 것으로 보입니다. $idToken');
      throw Exception('ID 토큰이 유효하지 않습니다.');
    }

    var url = Uri.parse(_baseUrl);
    try {
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('사용자 데이터를 불러오는 데 실패했습니다: ${response.body}');
        throw Exception('사용자 데이터를 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('요청을 보내는 도중 오류가 발생했습니다: $e');
      throw Exception('사용자 데이터를 불러오는 데 실패했습니다.');
    }
  }

  Future<User> updateUser(String idToken, UserUpdateDto userUpdateDto) async {
    final url = Uri.parse('$_baseUrl/update');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: json.encode(userUpdateDto.toJson()),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('사용자 정보 업데이트 실패: ${response.body}');
      throw Exception('Failed to update user.');
    }
  }
}



// 예를 들어, 다른 곳에서 이 UserApi를 사용할 때는 다음과 같이 사용할 수 있습니다.
// final userApi = UserApi();
// final userInfo = await userApi.getUserInfo(ref); // 'ref'는 ProviderReference 객체입니다.
