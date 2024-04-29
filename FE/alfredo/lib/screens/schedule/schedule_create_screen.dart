import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import 'schedule_list_screen.dart';

class ScheduleCreateScreen extends StatefulWidget {
  const ScheduleCreateScreen({super.key});

  @override
  _ScheduleCreateScreenState createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<ScheduleCreateScreen> {
  final ScheduleController controller = ScheduleController();
  final _formKey = GlobalKey<FormState>();

  String title = '';
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool startAlarm = false; // 시작 알람 설정
  String? place;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool withTime = true; // 시간 사용 여부

  // 날짜 선택기
  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // 시간 선택기
  Future<void> _selectTime(BuildContext context,
      {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          isStart ? startTime ?? TimeOfDay.now() : endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 생성")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: '일정 제목'),
              onSaved: (value) => title = value ?? '',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            ListTile(
              title:
                  Text('시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
              onTap: () => _selectDate(context, isStart: true),
            ),
            ListTile(
              title: Text(
                  '종료 날짜: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : "선택되지 않음"}'),
              onTap: () => _selectDate(context, isStart: false),
            ),
            SwitchListTile(
              title: const Text('알람 사용'),
              value: startAlarm,
              onChanged: (bool value) {
                setState(() {
                  startAlarm = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('하루 종일'),
              value: withTime,
              onChanged: (bool value) {
                setState(() {
                  withTime = value;
                  if (!value) {
                    startTime = null;
                    endTime = null;
                  }
                });
              },
            ),
            if (!withTime) // withTime이 false일 때만 시간 설정을 보여줌
              Column(
                children: [
                  ListTile(
                    title: Text(
                        '시작 시간: ${startTime != null ? startTime!.format(context) : "선택되지 않음"}'),
                    onTap: () => _selectTime(context, isStart: true),
                  ),
                  ListTile(
                    title: Text(
                        '종료 시간: ${endTime != null ? endTime!.format(context) : "선택되지 않음"}'),
                    onTap: () => _selectTime(context, isStart: false),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                if (_validateForm()) {
                  _formKey.currentState!.save();
                  var newSchedule = Schedule(
                    scheduleTitle: title,
                    startDate: startDate,
                    endDate: endDate,
                    startAlarm: startAlarm,
                    place: place,
                    startTime: startTime,
                    endTime: endTime,
                    withTime: withTime,
                  );
                  controller.createSchedule(newSchedule).then((value) {
                    print(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('일정이 성공적으로 생성되었습니다.')));
                    // 생성후 바로 전체 조회 가능하게 변경
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleListScreen()),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('일정 생성에 실패했습니다: $error')));
                  });
                }
              },
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    bool isValid = _formKey.currentState!.validate();
    if (!withTime && (startTime == null || endTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('시작 시간과 종료 시간을 모두 입력해야 합니다.')));
      isValid = false;
    }
    return isValid;
  }
}
