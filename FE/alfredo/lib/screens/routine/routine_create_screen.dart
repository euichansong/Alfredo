import 'package:flutter/material.dart';

//TODO 모달창으로 만들기
class RoutineCreateScreen extends StatelessWidget {
  const RoutineCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "RoutineList",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
