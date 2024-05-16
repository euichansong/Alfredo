// ignore_for_file: unused_import

import 'package:alfredo/provider/calendar/icaldata_provider.dart';
import 'package:alfredo/provider/user/user_state_provider.dart';
import 'package:alfredo/screens/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/todo/todo_list.dart'; // TodoList 위젯 import
import '../tts/tts_page.dart';

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
                image: AssetImage('assets/mainback1.png'),
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image 12.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.44,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image 13.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.height * 0,
            right: MediaQuery.of(context).size.height * 0,
            bottom: MediaQuery.of(context).size.height * 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: TtsPage(),
              ),
            ),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.45,
            left: MediaQuery.of(context).size.height * 0.087,
            right: MediaQuery.of(context).size.height * 0.087,
            bottom: MediaQuery.of(context).size.height * 0.1,
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
            top: MediaQuery.of(context).size.height * 0.05,
            right: MediaQuery.of(context).size.height * 0.02,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const ShopScreen(),
                );
              },
              child: const Text('Shop'),
            ),
          ),
        ],
      ),
    );
  }
}
