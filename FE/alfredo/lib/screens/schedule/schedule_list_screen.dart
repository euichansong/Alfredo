import 'package:flutter/material.dart';
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import 'schedule_detail_screen.dart'; // 상세 화면 import
import 'schedule_create_screen.dart';

class ScheduleListScreen extends StatelessWidget {
  final ScheduleController controller = ScheduleController();

  ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 목록")),
      body: FutureBuilder<List<Schedule>>(
        future: controller.getSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("오류: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("일정이 없습니다"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var schedule = snapshot.data![index];
                return Dismissible(
                  key: Key(schedule.scheduleId.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    controller.deleteSchedule(schedule.scheduleId!);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(schedule.scheduleTitle),
                    subtitle: Text("${schedule.startDate} - ${schedule.endDate}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleDetailScreen(scheduleId: schedule.scheduleId!),
                        ),
                      );
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
      MaterialPageRoute(builder: (context) => ScheduleCreateScreen()),
    );
  },
  child: Icon(Icons.add),
),
    );
  }
}