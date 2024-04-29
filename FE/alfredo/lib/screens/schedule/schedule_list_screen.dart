import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import 'schedule_edit_screen.dart'; // 상세 화면 import
import 'schedule_create_screen.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final ScheduleController controller = ScheduleController();
  Future<List<Schedule>>? schedules;

  @override
  void initState() {
    super.initState();
    schedules = controller.getSchedules(); // 일정 목록 로드
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 목록")),
      body: FutureBuilder<List<Schedule>>(
        future: schedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("오류: ${snapshot.error}"));
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("일정이 없습니다"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var schedule = snapshot.data![index];
                String startDateText =
                    DateFormat('yyyy-MM-dd').format(schedule.startDate);
                String endDateText = schedule.endDate != null
                    ? DateFormat('yyyy-MM-dd').format(schedule.endDate!)
                    : startDateText; // If no end date, use start date
                String displayText =
                    _buildDisplayText(schedule, startDateText, endDateText);

                return Dismissible(
                  key: Key(schedule.scheduleId.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.deleteSchedule(schedule.scheduleId!);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(schedule.scheduleTitle),
                    subtitle: Text(displayText),
                    onTap: () {
                      // 수정 화면으로 이동
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleEditScreen(
                                scheduleId: schedule.scheduleId!),
                          ));
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("데이터가 없습니다"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ScheduleCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _buildDisplayText(
      Schedule schedule, String startDateText, String endDateText) {
    if (schedule.withTime) {
      return "$startDateText - $endDateText";
    } else {
      String startTimeText = schedule.startTime != null
          ? ' ${schedule.startTime!.format(context)}'
          : '';
      String endTimeText = schedule.endTime != null
          ? ' ${schedule.endTime!.format(context)}'
          : '';
      return "$startDateText$startTimeText - $endDateText$endTimeText";
    }
  }
}
