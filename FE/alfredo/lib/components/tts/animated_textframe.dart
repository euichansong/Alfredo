import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedTextFrame extends StatefulWidget {
  final Function onTextTap;
  const AnimatedTextFrame({super.key, required this.onTextTap});

  @override
  AnimatedTextFrameState createState() => AnimatedTextFrameState();
}

class AnimatedTextFrameState extends State<AnimatedTextFrame> {
  late List<String> stringList;
  late String displayedText;
  bool isApiTextDisplayed = false; // 현재 표시되는 텍스트가 API 텍스트인지 여부

  @override
  void initState() {
    super.initState();
    setupTextList();
    displayedText = stringList.first;
  }

  void setupTextList() {
    DateTime now = DateTime.now();
    int hour = now.hour; // 현지 시간대의 시간을 사용

    if (hour >= 0 && hour < 6) {
      stringList = [
        '새벽 리스트: 조용하고 평화로운 텍스트입니다.',
        '새벽 리스트: 달빛 아래 산책하는 느낌의 텍스트입니다.',
        '새벽 리스트: 기일어요 길어요 길어요 길어어어어어어어어어어어어어 일이삼사 테스트테스트 테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트',
      ];
    } else if (hour >= 6 && hour < 12) {
      stringList = [
        '오전 리스트: 활기찬 하루를 시작하는 텍스트입니다.',
        '오전 리스트: 일과 중 휴식을 취하며 읽는 텍스트입니다.',
      ];
    } else if (hour >= 12 && hour < 18) {
      stringList = [
        '낮 리스트: 활기찬 하루를 시작하는 텍스트입니다.',
        '낮 리스트: 일과 중 휴식을 취하며 읽는 텍스트입니다.',
      ];
    } else {
      stringList = [
        '밤 리스트: 하루를 마무리하며 읽는 텍스트입니다.',
        '밤 리스트: 편안한 밤을 위한 텍스트입니다.',
      ];
    }
  }

  void changeText() {
    final newText = stringList[Random().nextInt(stringList.length)];
    setState(() {
      displayedText = newText;
      isApiTextDisplayed = false; // 로컬 리스트로 변경 시 상태 해제
    });
  }

  // API로부터 받은 새 텍스트로 업데이트
  void updateText(String newText) {
    setState(() {
      displayedText = newText;
      isApiTextDisplayed = true; // API 텍스트가 표시 중임을 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTextTap(); // 사용자 정의 콜백 실행
        changeText(); // 텍스트 변경 함수 실행
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Text(
            displayedText,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
