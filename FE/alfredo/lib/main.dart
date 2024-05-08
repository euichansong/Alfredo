import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/navbar/tabview.dart';
import 'config/firebase_options.dart';
import 'screens/calendar/calendar.dart';
import 'screens/user/login_page.dart';
import 'screens/user/user_routine_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
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
        '/main': (context) => const TabView(),
        '/user_routine_test': (context) => const UserRoutineTestPage(),
        '/calendar': (context) => const Calendar(),
      },
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        // ... app-specific localization delegate[s] here
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      locale: const Locale('ko'),
    );
  }
}
