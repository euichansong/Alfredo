import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 여기다가 각자 작업하는 페이지로 가는 push 버튼 만들어서 작업 ㄱㄱ
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
    );
  }
}
