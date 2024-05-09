import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import 'schedule_list_screen.dart';
import '../../provider/schedule/schedule_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../services/firebase_messaging_service.dart';
import '../../api/alarm/alarm_api.dart';

class ScheduleCreateScreen extends ConsumerWidget {
  const ScheduleCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(scheduleControllerProvider);
    return _ScheduleCreateScreenBody(controller: controller);
  }
}

class _ScheduleCreateScreenBody extends StatefulWidget {
  final ScheduleController controller;

  const _ScheduleCreateScreenBody({super.key, required this.controller});

  @override
  _ScheduleCreateScreenState createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<_ScheduleCreateScreenBody> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  bool startAlarm = false;
  TimeOfDay? alarmTime; // 사용자가 설정한 알람 시간
  String? place;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool withTime = true;
  int? selectedAlarmOption;

  @override
  void initState() {
    super.initState();
    endDate = startDate; // 종료 날짜의 초기값을 시작 날짜와 동일하게 설정합니다.
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
            _buildDatePicker('시작 날짜', startDate, isStartDate: true),
            _buildDatePicker('종료 날짜', endDate ?? startDate, isStartDate: false),
            _buildSwitchTile('알람 사용', startAlarm, (value) {
              setState(() {
                startAlarm = value;
                selectedAlarmOption = null; // 알람 사용이 변경될 때 선택 옵션 초기화
              });
            }),
            if (startAlarm) _buildAlarmOptions(),
            _buildSwitchTile('하루 종일', withTime, (value) {
              setState(() {
                withTime = value;
                startTime = endTime = null; // 하루 종일 설정이 변경될 때 시간 초기화
              });
            }),
            if (!withTime) _buildTimePicker('시작 시간', startTime, true),
            if (!withTime) _buildTimePicker('종료 시간', endTime, false),
            _buildTextField('장소', (value) => place = value),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
    );
  }

  Widget _buildDatePicker(String label, DateTime date,
      {required bool isStartDate}) {
    return ListTile(
      title: Text('$label: ${DateFormat('yyyy-MM-dd').format(date)}'),
      onTap: () => _selectDate(context, isStart: isStartDate),
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        onChanged(newValue);
        // startAlarm이 true로 설정되면 alarmTime을 오전 9시로 설정
        if (newValue && title == '알람 사용') {
          setState(() {
            alarmTime = const TimeOfDay(hour: 9, minute: 0);
          });
        } else if (!newValue && title == '알람 사용') {
          // 알람 사용이 false로 변경되면 alarmTime을 null로 설정
          setState(() {
            alarmTime = null;
          });
        }
      },
    );
  }

// 알람 사용시 리스트
  Widget _buildAlarmOptions() {
    List<String> options = withTime
        ? ['일정 당일 오전 9시', '일정 당일 오전 12시', '사용자 설정']
        : ['시작 1시간 전', '시작 30분 전', '사용자 설정'];

    return Column(
      children: List<Widget>.generate(
          options.length,
          (index) => ListTile(
                title: _buildOptionTitle(index),
                trailing: selectedAlarmOption == index
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    selectedAlarmOption = index;
                    _updateAlarmTime(index);
                  });
                },
              )),
    );
  }

// 옵션 옆 시간 계산 함수
  Widget _buildOptionTitle(int index) {
    String optionText;
    if (index == 2) {
      optionText = '사용자 설정';
      if (alarmTime != null) {
        optionText += ' (${alarmTime!.format(context)})'; // 설정된 알람 시간 표시
      }
    } else {
      List<String> defaultOptions = withTime
          ? ['일정 당일 오전 9시', '일정 당일 오전 12시']
          : [
              '시작 1시간 전 (${_calculateStartTime(1).format(context)})',
              '시작 30분 전 (${_calculateStartTime(0.5).format(context)})'
            ];
      optionText = defaultOptions[index];
    }
    return Text(optionText);
  }

// 시간 계산 함수
  TimeOfDay _calculateStartTime(double hoursBefore) {
    DateTime baseDateTime;
    if (withTime) {
      // withTime이 True인 경우
      baseDateTime =
          DateTime(startDate.year, startDate.month, startDate.day, 9, 0);
    } else {
      // withTime이 False인 경우
      if (startTime != null) {
        baseDateTime = DateTime(startDate.year, startDate.month, startDate.day,
            startTime!.hour, startTime!.minute);
        baseDateTime = baseDateTime.subtract(Duration(
            hours: hoursBefore.toInt(),
            minutes: ((hoursBefore % 1) * 60).toInt()));
      } else {
        baseDateTime = DateTime.now();
      }
    }
    return TimeOfDay.fromDateTime(baseDateTime);
  }

  void _updateAlarmTime(int optionIndex) {
    if (optionIndex == 2) {
      // '사용자 설정' 선택시
      _selectAlarmTime(context);
    } else {
      DateTime baseDateTime;
      if (optionIndex == 0) {
        // '일정 당일 오전 9시' 또는 '시작 1시간 전'
        if (withTime) {
          // withTime이 True인 경우
          baseDateTime =
              DateTime(startDate.year, startDate.month, startDate.day, 9, 0);
        } else {
          // withTime이 False인 경우
          if (startTime != null) {
            baseDateTime = DateTime(startDate.year, startDate.month,
                startDate.day, startTime!.hour, startTime!.minute);
            baseDateTime = baseDateTime.subtract(const Duration(hours: 1));
          } else {
            baseDateTime = DateTime.now();
          }
        }
      } else if (optionIndex == 1) {
        // '일정 당일 오전 12시' 또는 '시작 30분 전'
        if (withTime) {
          // withTime이 True인 경우
          baseDateTime =
              DateTime(startDate.year, startDate.month, startDate.day, 12, 0);
        } else {
          // withTime이 False인 경우
          if (startTime != null) {
            baseDateTime = DateTime(startDate.year, startDate.month,
                startDate.day, startTime!.hour, startTime!.minute);
            baseDateTime = baseDateTime.subtract(const Duration(minutes: 30));
          } else {
            baseDateTime = DateTime.now();
          }
        }
      } else {
        // '사용자 설정'을 선택했을 때
        if (startTime != null) {
          baseDateTime = DateTime(startDate.year, startDate.month,
              startDate.day, startTime!.hour, startTime!.minute);
          baseDateTime = baseDateTime.subtract(const Duration(hours: 1));
        } else {
          baseDateTime = DateTime.now();
        }
      }
      alarmTime = TimeOfDay.fromDateTime(baseDateTime);
    }
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, bool isStartTime) {
    return ListTile(
      title: Text('$label: ${time != null ? time.format(context) : "선택되지 않음"}'),
      onTap: () => _selectTime(context, isStart: isStartTime),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_validateForm()) {
          _formKey.currentState!.save();
          var newSchedule = Schedule(
            scheduleTitle: title,
            startDate: startDate,
            endDate: endDate,
            startAlarm: startAlarm,
            alarmTime: alarmTime,
            place: place,
            startTime: startTime,
            endTime: endTime,
            withTime: withTime,
          );
          try {
            // 디바이스 토큰을 가져옵니다.
            String? token = await FirebaseMessaging.instance.getToken();
            print('Firebase Messaging Token: $token');

            // 일정 생성 및 디바이스 토큰과 일정 정보를 백엔드로 전송
            if (startAlarm && token != null) {
              await widget.controller.createSchedule(newSchedule);
              AlarmApi alarmApi = AlarmApi();
              String formattedDateTime =
                  alarmApi.formatScheduleDateTime(startDate, alarmTime);
              await alarmApi.sendTokenAndScheduleData(
                  token, title, formattedDateTime);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('일정이 성공적으로 생성되었으며 알림이 설정되었습니다.')));
            } else {
              await widget.controller.createSchedule(newSchedule);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('일정이 성공적으로 생성되었습니다.')));
            }
            // 일정 목록 화면으로 이동
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScheduleListScreen()));
          } catch (error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('일정 생성에 실패했습니다: $error')));
          }
        }
      },
      child: const Text('저장'),
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

  // 날짜 설정
  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    DateTime initialDate = isStart ? startDate : (endDate ?? startDate);
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    if (!isStart) {
      // 종료일 선택기에 대해 시작일을 최소 날짜로 설정
      firstDate = startDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          // 시작일이 변경되었을 때 종료일이 시작일보다 이전인 경우를 처리
          if (endDate != null && endDate!.isBefore(startDate)) {
            endDate = startDate; // 종료일을 시작일로 자동 설정
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  // 시간 설정
  Future<void> _selectTime(BuildContext context,
      {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (endTime ?? const TimeOfDay(hour: 9, minute: 0)),
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

  Future<void> _selectAlarmTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: alarmTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        alarmTime = picked;
      });
    }
  }
}
