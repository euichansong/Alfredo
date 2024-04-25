import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../api/token_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      // 사용자가 로그인 상태인 경우, main_page.dart로 바로 리디렉션합니다.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/main');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/alfredoback1.png',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/alfredologo2.png',
                width: MediaQuery.of(context).size.width * 0.63,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                if (_currentUser == null)
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 385.0), // 로그인 버튼의 위치를 조정
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _signInWithGoogle,
                        borderRadius: BorderRadius.circular(22),
                        splashColor: Colors.grey.withAlpha(30),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/android_light_rd_ctn@2x.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          width: 250,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                if (_currentUser != null) ...[
                  Text('Logged in as: ${_currentUser?.email ?? "No Email"}'),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text('Logout'),
                  ),
                ],
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      AuthService authService = AuthService();
      UserCredential? userCredential = await authService.signInWithGoogle();

      if (userCredential != null) {
        print("Login successful!");
        // 사용자의 ID 토큰을 가져옵니다.
        final idToken = await userCredential.user?.getIdToken();

        if (idToken != null) {
          await TokenApi.sendTokenToServer(idToken); // 서버에 토큰 전송
        }

        // Firebase Auth에 사용자가 존재하는지 확인합니다.
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          // 최초 로그인한 사용자라면 user_routine_test.dart로 리디렉션
          Navigator.pushReplacementNamed(context, '/user_routine_test');
        } else {
          // 기존 사용자라면 main_page.dart로 리디렉션
          Navigator.pushReplacementNamed(context, '/main');
        }
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
