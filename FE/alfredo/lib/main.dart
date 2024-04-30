import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';
import 'screens/user/login_page.dart';
import 'screens/mainpage/main_page.dart';
import 'screens/user/user_routine_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    );
  }
}
