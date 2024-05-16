import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/user/survey_save.dart';
import 'components/navbar/tabview.dart';
import 'config/firebase_options.dart';
import 'screens/calendar/calendar.dart';
import 'screens/user/login_page.dart';
import 'screens/user/user_routine_test.dart';
import 'services/firebase_messaging_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessagingService fcmService = FirebaseMessagingService();
  await fcmService.setupInteractions();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _authService.getIdToken(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alfredo',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const TabView(),
        '/user_routine_test': (context) => const UserRoutineTestPage(),
        '/survey_save': (context) => const SurveySavePage(),
        '/calendar': (context) => const Calendar(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kyobo', // 전역 글꼴로 Koybo를 사용
      ),
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
