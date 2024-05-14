import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SurveySavePage extends ConsumerStatefulWidget {
  const SurveySavePage({super.key});

  @override
  _SurveySavePageState createState() => _SurveySavePageState();
}

class _SurveySavePageState extends ConsumerState<SurveySavePage> {
  Future<void> _fetchAndSaveRoutines() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String? idToken = await user?.getIdToken(true);

      if (idToken == null) {
        throw Exception('No ID Token found');
      }

      // 루틴 추천 API 요청
      final recommendResponse = await http.get(
        Uri.parse('${dotenv.env['USER_API_URL']}/basic'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (recommendResponse.statusCode == 200) {
        final recommendData = json.decode(recommendResponse.body);
        final basicRoutineIds = List<int>.from(recommendData['basicRoutineId']);

        // 추천받은 루틴 등록 API 요청
        final registerResponse = await http.post(
          Uri.parse('${dotenv.env['ROUTINE_API_URL']}/add-basic-routines'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: json.encode({
            'basicRoutineIds': basicRoutineIds,
          }),
        );

        if (registerResponse.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          print('Failed to register routines: ${registerResponse.body}');
        }
      } else {
        print(
            'Failed to fetch recommended routines: ${recommendResponse.body}');
      }
    } catch (e) {
      print('Error fetching and saving routines: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _fetchAndSaveRoutines,
          child: const Text('시작하기'),
        ),
      ),
    );
  }
}
