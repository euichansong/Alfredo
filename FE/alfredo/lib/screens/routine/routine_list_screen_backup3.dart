import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../api/routine/routine_api.dart';
import '../../provider/routine/routine_provider.dart';
import '../../screens/routine/routine_detail_screen.dart';

class RoutineListScreen extends ConsumerStatefulWidget {
  const RoutineListScreen({super.key});

  @override
  _RoutineListScreenState createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends ConsumerState<RoutineListScreen> {
  final routineApi = RoutineApi();

  @override
  Widget build(BuildContext context) {
    final routines = ref.watch(routineProvider);

    print('$routines list screens');
    final screenWidth = MediaQuery.of(context).size.width; // 화면 크기 얻어오기
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        title: const Padding(
          padding: EdgeInsets.only(top: 16.0, left: 8),
          child: Text(
            "루틴 리스트",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF0D2338),
      body: routines.when(
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, left: 32.0),
                child: Text(
                  '${data.length}개',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 15.0, bottom: 20), // 리스트 위, 아래에 패딩 추가
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final routine = data[index];
                    return Dismissible(
                      key: Key(routine.id
                          .toString()), // Provide a unique key for each item
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        await routineApi.deleteRoutine(routine.id);
                        setState(() {
                          data.removeAt(index);
                        });
                        ref.refresh(routineProvider);
                      },
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoutineDetailScreen(
                              routine: routine,
                            ),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            color: const Color(0xFFF2E9E9),
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.10,
                              padding:
                                  const EdgeInsets.all(15.0), // 카드 내부에 패딩 추가
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.35,
                                    child: Text(
                                      routine.routineTitle,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children:
                                            _buildDayWidgets(routine.days),
                                      ),
                                      const SizedBox(width: 10), // 원하는 간격으로 조정
                                      Text(
                                        formatTimeOfDay(routine.startTime),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

List<Widget> _buildDayWidgets(Set<String> days) {
  const allDays = ["일", "월", "화", "수", "목", "금", "토"];
  const allDaysShort = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

  return List<Widget>.generate(7, (index) {
    final day = allDays[index];
    final dayShort = allDaysShort[index];
    final isSelected = days.contains(dayShort);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Text(
        day,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.black : Colors.grey,
          fontSize: 12, // 글자 크기 설정
        ),
      ),
    );
  });
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); // Use 'jm' for AM/PM format
  return format.format(dt);
}
