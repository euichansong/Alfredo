import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import 'schedule_edit_screen.dart';
import 'schedule_create_screen.dart';
import '../../provider/schedule/schedule_provider.dart';

class ScheduleListScreen extends ConsumerStatefulWidget {
  const ScheduleListScreen({Key? key}) : super(key: key);

  @override
  _ScheduleListScreenState createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends ConsumerState<ScheduleListScreen> {
  Future<List<Schedule>>? schedules;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() {
    schedules = ref.read(scheduleControllerProvider).getSchedules();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule List")),
      body: FutureBuilder<List<Schedule>>(
        future: schedules,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text("No schedules available"));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              var schedule = snapshot.data![index];
              return buildScheduleItem(context, schedule);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the create screen and refresh the list if a new item was added
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ScheduleCreateScreen()),
          );
          if (result == true) {
            _loadSchedules();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildScheduleItem(BuildContext context, Schedule schedule) {
    String startDateText = DateFormat('yyyy-MM-dd').format(schedule.startDate);
    String endDateText = schedule.endDate != null
        ? DateFormat('yyyy-MM-dd').format(schedule.endDate!)
        : startDateText;
    String displayText =
        _buildDisplayText(schedule, startDateText, endDateText);

    return Dismissible(
      key: Key(schedule.scheduleId.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        // Delete the schedule and then refresh the list
        await ref
            .read(scheduleControllerProvider)
            .deleteSchedule(schedule.scheduleId!);
        // Use setState to trigger a re-render of the widget, thus updating the list
        setState(() {
          _loadSchedules(); // Refresh the list after deleting an item
        });
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
        onTap: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ScheduleEditScreen(scheduleId: schedule.scheduleId!)),
          );
          if (result == true) {
            _loadSchedules();
          }
        },
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
