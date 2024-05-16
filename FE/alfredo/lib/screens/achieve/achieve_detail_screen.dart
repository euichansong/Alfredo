import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/achieve/achieve_model.dart';
import '../../provider/achieve/achieve_provider.dart';
import 'dart:ui';
import 'package:intl/intl.dart';

class AchieveDetailScreen extends ConsumerWidget {
  const AchieveDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achieveAsyncValue = ref.watch(achieveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("업적 상세", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff0d2338),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xffD6C3C3),
      body: achieveAsyncValue.when(
        data: (achieve) => _buildAchieveList(context, achieve),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildAchieveList(BuildContext context, Achieve achieve) {
    final achieveStatuses = [
      {
        "title": "첫번째 업적",
        "status": achieve.achieveOne,
        "description": "총 수행시간 업적",
        "date": achieve.finishOne
      },
      {
        "title": "2번째 업적",
        "status": achieve.achieveTwo,
        "description": "첫 ical 등록 업적",
        "date": achieve.finishTwo
      },
      {
        "title": "3번째 업적",
        "status": achieve.achieveThree,
        "description": "토요일부터 토요일 7일간 할일",
        "date": achieve.finishThree
      },
      {
        "title": "4번째 업적",
        "status": achieve.achieveFour,
        "description": "총 루틴 갯수 몇개이상",
        "date": achieve.finishFour
      },
      {
        "title": "5번째 업적",
        "status": achieve.achieveFive,
        "description": "총 투두 갯수 몇개 이상",
        "date": achieve.finishFive
      },
      {
        "title": "6번째 업적",
        "status": achieve.achieveSix,
        "description": "총 일정 갯수 몇개 이상",
        "date": achieve.finishSix
      },
      {
        "title": "9번째 업적",
        "status": achieve.achieveNine,
        "description": "생일 등록자가 오늘이 생일인 경우",
        "date": achieve.finishNine
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: achieveStatuses.length,
      itemBuilder: (context, index) {
        final achieveStatus = achieveStatuses[index];
        return _buildAchieveCard(
          achieveStatus["title"] as String,
          achieveStatus["status"] as bool,
          achieveStatus["description"] as String,
          achieveStatus["date"] as DateTime?,
        );
      },
    );
  }

  Widget _buildAchieveCard(
      String title, bool status, String description, DateTime? date) {
    if (title == "5번째 업적") {
      print('finishFive: $date');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: const Color(0xffE7D8BC),
            elevation: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xff0d2338),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xff0d2338),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (date != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '달성일: ${DateFormat('yyyy-MM-dd').format(date)}',
                        style: const TextStyle(
                          color: Color(0xff0d2338),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (!status)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
