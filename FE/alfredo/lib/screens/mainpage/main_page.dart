import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/todo/todo_list.dart'; // TodoList 위젯 import
import '../../provider/attendance/attendance_provider.dart';
import '../../provider/user/future_provider.dart';
import '../tts/tts_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    _checkAttendance();
  }

  Future<void> _checkAttendance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastCheckDate = prefs.getString('lastCheckDate');
    final String todayDate = DateTime.now().toString().substring(0, 10);

    if (lastCheckDate != todayDate) {
      final idToken = await ref.read(authManagerProvider.future);
      try {
        await ref.read(attendanceProvider).checkAttendance(idToken);
        await prefs.setString('lastCheckDate', todayDate);
        _showAttendanceModal();
      } catch (error) {
        print('Failed to check attendance: $error');
      }
    }
  }

  void _showAttendanceModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('출석 체크 완료'),
          content: const Text('오늘의 출석이 완료되었습니다!'),
          actions: [
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mainalfredo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.height * 0,
            right: MediaQuery.of(context).size.height * 0,
            bottom: MediaQuery.of(context).size.height * 0.06,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: TtsPage(),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.48,
            left: MediaQuery.of(context).size.height * 0.01,
            right: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              // ignore: prefer_const_constructors
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: const TodoList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
