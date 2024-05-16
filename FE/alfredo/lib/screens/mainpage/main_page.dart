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
    //TODO !=로 변경
    if (lastCheckDate == todayDate) {
      final idToken = await ref.read(authManagerProvider.future);
      try {
        await ref.read(attendanceProvider).checkAttendance(idToken);
        print("여기 실행 중");
        await prefs.setString('lastCheckDate', todayDate);
        List<DateTime> attendanceHistory = await ref
            .read(attendanceProvider)
            .getAttendanceForCurrentWeek(idToken);
        _showAttendanceModal(attendanceHistory);
      } catch (error) {
        print('Failed to check attendance: $error');
      }
    }
  }

  void _showAttendanceModal(List<DateTime> attendanceHistory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('이번 주 출석 현황'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(
              maxHeight: 200, // 모달의 최대 높이를 설정
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildAttendanceList(attendanceHistory),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAttendanceList(List<DateTime> attendanceHistory) {
    List<Widget> attendanceWidgets = [];
    Map<int, String> daysOfWeek = {
      DateTime.sunday: "일",
      DateTime.monday: "월",
      DateTime.tuesday: "화",
      DateTime.wednesday: "수",
      DateTime.thursday: "목",
      DateTime.friday: "금",
      DateTime.saturday: "토"
    };

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      bool attended = attendanceHistory.any((date) =>
          date.year == day.year &&
          date.month == day.month &&
          date.day == day.day);
      attendanceWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    attended ? Colors.blueAccent : Colors.grey[300],
                child: Icon(
                  attended ? Icons.check : Icons.close,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                daysOfWeek[day.weekday]!,
                style: TextStyle(
                  color: attended ? Colors.blueAccent : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return attendanceWidgets;
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
