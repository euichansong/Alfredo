import 'package:alfredo/provider/calendar/icaldata_provider.dart';
import 'package:alfredo/provider/user/user_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/todo/todo_list.dart'; // TodoList 위젯 import
import '../tts/tts_page.dart';
import '../achieve/achieve_detail_screen.dart'; // AchieveDetailScreen import
import '../coin/coin_detail_screen.dart'; // CoinDetailScreen import
import '../../provider/achieve/achieve_provider.dart'; // achieveProvider import
import '../../provider/coin/coin_provider.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/mainalfredo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.height * 0,
            right: MediaQuery.of(context).size.height * 0,
            bottom: MediaQuery.of(context).size.height * 0.06,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                child: TtsPage(),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.48,
            left: MediaQuery.of(context).size.height * 0.01,
            right: MediaQuery.of(context).size.height * 0.01,
            bottom: MediaQuery.of(context).size.height * 0.01,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const TodoList(),
            ),
          ),
          // 업적 화면으로 이동하는 버튼
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.5 -
                30, // 버튼의 절반 너비를 빼서 중앙으로 위치시킴
            child: FloatingActionButton(
              onPressed: () async {
                // 업적 데이터를 새로고침
                ref.refresh(achieveProvider);
                // 업적 화면으로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AchieveDetailScreen()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.star),
            ),
          ),
          // 코인 화면으로 이동하는 버튼
          // Positioned(
          //   top: MediaQuery.of(context).size.height * 0.2,
          //   left: MediaQuery.of(context).size.width * 0.5 -
          //       30, // 버튼의 절반 너비를 빼서 중앙으로 위치시킴
          //   child: FloatingActionButton(
          //     onPressed: () async {
          //       // 코인 데이터를 새로고침
          //       ref.refresh(coinProvider);
          //       // 코인 화면으로 이동
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => const CoinDetailScreen()),
          //       );
          //     },
          //     backgroundColor: Colors.green,
          //     child: const Icon(Icons.monetization_on),
          //   ),
          // ),
        ],
      ),
    );
  }
}
