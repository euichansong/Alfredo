import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/user/user_state_provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../components/chart/bar_chart.dart';
import '../../components/chart/chart_container.dart';
import './user_update.dart';

class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  void openUserUpdateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const UserUpdateScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff0d2338),
        title: const Text(
          'MyPage',
          selectionColor: Color(0xFFF2E9E9),
        ),
      ),
      backgroundColor: const Color(0xFFF2E9E9),
      body: userState.when(
        data: (user) => ListView(
          padding: const EdgeInsets.only(top: 30),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 26.0),
                child: Text(user.nickname,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF0D2338)),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('내 정보',
                          style: Theme.of(context).textTheme.titleLarge),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // 모달 창을 여는 함수를 호출
                          openUserUpdateModal(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('이메일: '),
                      Text(user.email ?? '이메일 없음'),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('생일: '),
                      Text(
                        user.birth != null
                            ? DateFormat('yyyy-MM-dd').format(user.birth!)
                            : '생일 없음',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 80, // 최대 너비를 100으로 설정
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: const Text(
                  '오늘 한 일',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            const ChartContainer(
                title: '요일별 달성',
                color: Color(0xffD6C3C3),
                chart: BarChartContent()),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
    );
  }
}
