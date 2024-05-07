import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/firebase_options.dart';
import 'screens/mainpage/main_page.dart';
import 'screens/user/login_page.dart';
import 'screens/user/user_routine_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //FCM 토큰 가져오기
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("Firebase Messaging Token: $token");
  // FirebaseMessaging.instance.getInitialMessage();
  // foreground work
  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      print(message.notification!.body);
      print(message.notification!.title);
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alfredo',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/user_routine_test': (context) => const UserRoutineTestPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
