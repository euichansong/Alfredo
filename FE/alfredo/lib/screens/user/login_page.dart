import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../api/token_api.dart';

import '../../services/auth_service.dart';

import 'loading_screen.dart';
import '../../components/navbar/tabview.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  User? _currentUser;
  final bool _isLoading = false; // 로딩 상태 관리 변수

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
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
          _isLoading
              ? const MyLoadingScreen()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Spacer(),
                      if (_currentUser == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 385.0),
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
          await TokenApi.sendTokenToServer(idToken);
        }


        //여기서부터 표시한곳까지 추가
        // 사용자의 Firebase Messaging 토큰을 가져옵니다.
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          debugPrint("Firebase Messaging Token: $fcmToken");
          if (idToken != null) {
            TokenApi.sendFcmTokenToServer(idToken, fcmToken);
          }
        }
        //여기까지 추가

        // Firebase Auth에 사용자가 존재하는지 확인합니다.

        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
        if (isNewUser) {
          Navigator.pushReplacementNamed(context, '/user_routine_test');
        } else {
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
