import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _currentUser == null
            ? ElevatedButton(
                onPressed: _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Image.asset('assets/android_light_rd_ctn@2x.png'),
              )

            // 테스트용으로 쓸때 로그인 하면 원하는 페이지로 이동을 위한 버튼을 여기 아래 column에다 추가 ㄱㄱ
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Logged in as: ${_currentUser?.email ?? "No Email"}'),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      AuthService authService = AuthService();
      UserCredential? userCredential = await authService.signInWithGoogle();
      if (userCredential != null) {
        print("Login successful!");
      } else {
        print("Login failed.");
      }
    } catch (e) {
      print("Login error: $e");
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Logged out");
  }
}
