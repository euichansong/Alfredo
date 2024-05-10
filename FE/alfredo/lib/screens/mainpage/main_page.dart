import 'package:flutter/material.dart';

import '../../components/todo/todo_list.dart'; // TodoList 위젯 import

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: prefer_const_constructors
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
            top: MediaQuery.of(context).size.height * 0.45,
            left: MediaQuery.of(context).size.height * 0.07,
            right: MediaQuery.of(context).size.height * 0.07,
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const SizedBox(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: TodoList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
