import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../user/loading_screen.dart';
import '../routine/routine_list_screen.dart';
import '../schedule/schedule_list_screen.dart';
import '../user/mypage.dart';
import '../../components/navbar/tabview.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                print("Logged out"); // 정상적으로 로그아웃
                Navigator.pushReplacementNamed(context, '/'); // 로그인 페이지로 리디렉션
              } catch (e) {
                print("Logout failed: $e");
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const RoutineListScreen()), // RoutineListScreen으로 이동
                  // const RoutineCreateScreen()),
                );
              },
              child: const Text('Routines'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPage()),
                );
              },
              child: const Text('Go to My Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ScheduleListScreen()),
                );
              },
              child: const Text('Schedules'),
            ),
          ],
        ),
      ),
    );
  }
}
