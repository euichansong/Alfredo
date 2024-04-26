import 'package:flutter/material.dart';
import '../../controller/schedule/schedule_controller.dart'; // controller 경로 조정
import '../../models/schedule/schedule_model.dart'; // 모델 경로 조정

class ScheduleListScreen extends StatelessWidget {
  final ScheduleController controller = ScheduleController();

  ScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedules")),
      body: FutureBuilder<List<Schedule>>(
        future: controller.getSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 오류 메시지를 더 구체적으로 표시할 수 있습니다.
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No schedules found"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var schedule = snapshot.data![index];
                return ListTile(
                  title: Text(schedule.title),
                  subtitle: Text("${schedule.startDate} - ${schedule.endDate}"),
                  onTap: () {
                    // 여기에 특정 스케줄을 탭했을 때의 액션을 추가할 수 있습니다.
                  },
                );
              },
            );
          } else {
            // 데이터가 없을 경우
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
