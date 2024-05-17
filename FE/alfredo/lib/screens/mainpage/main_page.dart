// ignore_for_file: unused_import

import 'package:alfredo/provider/calendar/icaldata_provider.dart';
import 'package:alfredo/provider/store/store_provider.dart';
import 'package:alfredo/provider/user/user_state_provider.dart';
import 'package:alfredo/screens/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/todo/todo_list.dart'; // TodoList 위젯 import
import '../../provider/achieve/achieve_provider.dart'; // achieveProvider import
import '../../provider/coin/coin_provider.dart';
import '../achieve/achieve_detail_screen.dart'; // AchieveDetailScreen import
import '../coin/coin_detail_screen.dart'; // CoinDetailScreen import
import '../tts/tts_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    var background = ref.watch(backgroundProvider);
    var character = ref.watch(characterProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.height * 0,
            right: MediaQuery.of(context).size.height * 0,
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(character),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image 11.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.height * 0,
            right: MediaQuery.of(context).size.height * 0,
            bottom: MediaQuery.of(context).size.height * 0.07,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                child: TtsPage(),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.48,
            left: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.height * 0.05,
            bottom: MediaQuery.of(context).size.height * 0.01,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              // ignore: prefer_const_constructors
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: const TodoList(),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.11,
            left: MediaQuery.of(context).size.height * 0.02,
            right: MediaQuery.of(context).size.height * 0.42,
            child: Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF0D2338)),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0))),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const FractionallySizedBox(
                          heightFactor: 0.9,
                          child: ShopScreen(),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
                // const SizedBox(height: 10), // 간격을 주기 위해 추가
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const AchieveDetailScreen(),
                //       ),
                //     );
                //   },
                //   child: const Text('Achievements'),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
