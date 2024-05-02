import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:alfredo/components/navbar.dart';
import '../user/mypage.dart'; // 'MyPage' 클래스가 정의된 파일을 임포트하세요.

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
                print("Logout failed: $e"); // 로그아웃 실패
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 기존 코드나 다른 버튼들을 여기에 포함시킬 수 있습니다.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyPage()), // MyPage 경로를 정의해야 합니다.
                );
              },
              child: const Text('Go to My Page'),
            ),
            // body: CustomNavBar(), // 기존 네비게이션 바나 다른 위젯을 사용할 경우
          ],
        ),
      ),
    );
  }
}
