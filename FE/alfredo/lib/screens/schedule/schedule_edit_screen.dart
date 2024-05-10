import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import '../../provider/schedule/schedule_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../api/alarm/alarm_api.dart';

class ScheduleEditScreen extends ConsumerStatefulWidget {
  final int scheduleId;

  const ScheduleEditScreen({super.key, required this.scheduleId});

  @override
  _ScheduleEditScreenState createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends ConsumerState<ScheduleEditScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _titleController;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _startAlarm = false;
  bool _withTime = true;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  TimeOfDay? _alarmTime; // 알람 시간 설정을 위한 변수
  DateTime? _alarmDate; // 알람 날짜 설정을 위한 변수
  int? _selectedAlarmOption; // 선택된 알람 옵션 인덱스
  String? _place;

  final AlarmApi alarmApi = AlarmApi();

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  void _loadSchedule() async {
    try {
      final schedule = await ref
          .read(scheduleControllerProvider)
          .getScheduleDetail(widget.scheduleId);
      _titleController = TextEditingController(text: schedule.scheduleTitle);
      _startDate = schedule.startDate;
      _endDate = schedule.endDate;
      _startAlarm = schedule.startAlarm;
      _withTime = schedule.withTime;
      _startTime = schedule.startTime;
      _endTime = schedule.endTime;
      _alarmTime = schedule.alarmTime;
      _alarmDate = schedule.alarmDate; // 알람 날짜 초기 설정
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('일정 로딩 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_titleController == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("일정 상세")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("일정 수정"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSchedule,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: buildFormFields(),
        ),
      ),
    );
  }

  List<Widget> buildFormFields() {
    return [
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: '일정 제목'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '제목을 입력해주세요';
          }
          return null;
        },
      ),
      ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text("시작 날짜: ${DateFormat('yyyy-MM-dd').format(_startDate)}"),
        onTap: () => _selectDate(context, isStart: true),
      ),
      ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(
            "종료 날짜: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '선택되지 않음'}"),
        onTap: () => _selectDate(context, isStart: false),
      ),
      SwitchListTile(
        title: const Text('알람 사용'),
        value: _startAlarm,
        onChanged: (bool value) {
          setState(() {
            _startAlarm = value;
            if (!value) {
              _alarmTime = null; // Turn off alarm time when alarm is disabled
              _alarmDate = null; // Also reset the alarm date
              _removeAlarmIfSet(); // Additional call to remove alarm if it's set and being turned off
            }
          });
        },
      ),
      if (_startAlarm) _buildAlarmOptions(),
      SwitchListTile(
        title: const Text('하루 종일'),
        value: _withTime,
        onChanged: (bool value) {
          setState(() {
            _withTime = value;
            if (!value) {
              _startTime = null;
              _endTime = null;
            }
          });
        },
      ),
      if (!_withTime)
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(
              '시작 시간: ${_startTime != null ? _startTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: true),
        ),
      if (!_withTime)
        ListTile(
          leading: const Icon(Icons.access_time_filled),
          title: Text(
              '종료 시간: ${_endTime != null ? _endTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: false),
        ),
      TextFormField(
        initialValue: _place,
        decoration: const InputDecoration(labelText: '장소'),
        onSaved: (value) => _place = value,
      ),
      ElevatedButton(
        onPressed: _updateSchedule,
        child: const Text('수정하기'),
      ),
    ];
  }

  Widget _buildAlarmOptions() {
    List<String> options = _withTime
        ? ['일정 당일 오전 9시', '일정 당일 오전 12시', '사용자 설정']
        : ['시작 1시간 전', '시작 30분 전', '사용자 설정'];

    return Column(
      children: List<Widget>.generate(
          options.length,
          (index) => ListTile(
                leading: const Icon(Icons.alarm),
                title: _buildOptionTitle(index),
                trailing: _selectedAlarmOption == index
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedAlarmOption = index;
                    if (index == 2) {
                      // '사용자 설정' 선택 시 시간 선택기 호출
                      _selectAlarmTime();
                    } else {
                      _updateAlarmTime(index);
                    }
                  });
                },
              )),
    );
  }

  Widget _buildOptionTitle(int index) {
    String optionText = index == 2
        ? '사용자 설정'
        : (_withTime
            ? ['일정 당일 오전 9시', '일정 당일 오전 12시'][index]
            : ['시작 1시간 전', '시작 30분 전'][index]);

    if (index == 2 && _alarmTime != null) {
      optionText += ' (${_alarmTime!.format(context)})';
    }
    return Text(optionText);
  }

  void _updateAlarmTime(int optionIndex) {
    DateTime baseDateTime = _calculateBaseDateTime(optionIndex);
    _alarmTime = TimeOfDay.fromDateTime(baseDateTime);
    _alarmDate = baseDateTime; // 알람 날짜 설정 업데이트
  }

  DateTime _calculateBaseDateTime(int optionIndex) {
    DateTime baseDateTime = DateTime.now(); // Default to now if no time is set
    if (optionIndex < 2) {
      // Specific times set for options 0 and 1
      int hour =
          optionIndex == 0 ? 9 : 12; // 9 AM for option 0, 12 PM for option 1
      baseDateTime =
          DateTime(_startDate.year, _startDate.month, _startDate.day, hour, 0);
    } else if (_startTime != null && !_withTime) {
      // User-set time for option 2
      baseDateTime = DateTime(_startDate.year, _startDate.month, _startDate.day,
          _startTime!.hour, _startTime!.minute);
      int minutesSubtract = optionIndex == 0 ? 60 : 30;
      baseDateTime = baseDateTime.subtract(Duration(minutes: minutesSubtract));
    }
    return baseDateTime;
  }

  void _selectDate(BuildContext context, {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _selectTime(BuildContext context, {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
          : (_endTime ?? const TimeOfDay(hour: 9, minute: 0)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectAlarmTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _alarmTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _alarmTime = picked;
        _alarmDate = DateTime(_startDate.year, _startDate.month, _startDate.day,
            _alarmTime!.hour, _alarmTime!.minute);
      });
    }
  }

  void _deleteSchedule() async {
    try {
      if (_startAlarm) {
        DateTime now = DateTime.now();
        if (_alarmDate != null && _alarmDate!.isAfter(now)) {
          // Only delete alarms that have not occurred yet
          await alarmApi.deleteAlarm(widget.scheduleId);
        }
      }

      await ref
          .read(scheduleControllerProvider)
          .deleteSchedule(widget.scheduleId);
      // 삭제 성공 후, 결과로 true를 반환합니다.
      Navigator.pop(context, true); // 결과로 true를 넘겨줍니다.
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('일정이 삭제되었습니다.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('일정 삭제 실패: $e')));
    }
  }

  void _updateSchedule() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var updatedSchedule = Schedule(
        scheduleId: widget.scheduleId,
        scheduleTitle: _titleController!.text,
        startDate: _startDate,
        endDate: _endDate,
        startAlarm: _startAlarm,
        alarmTime: _alarmTime,
        alarmDate: _alarmDate, // Include alarm date in the updated schedule
        place: _place,
        startTime: _startTime,
        endTime: _endTime,
        withTime: _withTime,
      );

      try {
        // 일정 정보를 업데이트합니다.
        await ref
            .read(scheduleControllerProvider)
            .updateSchedule(widget.scheduleId, updatedSchedule);

        // 알람 설정이 활성화되어 있고, 사용자가 토큰을 가지고 있다면 알람 정보도 업데이트합니다.
        if (_startAlarm &&
            _alarmDate != null &&
            _alarmDate!.isAfter(DateTime.now())) {
          String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            String formattedDateTime =
                alarmApi.formatScheduleDateTime(_alarmDate, _alarmTime);
            print(formattedDateTime);
            await alarmApi.updateAlarm(token, _titleController!.text,
                formattedDateTime, widget.scheduleId);
          }
        } else if (!_startAlarm) {
          await alarmApi.deleteAlarm(
              widget.scheduleId); // Ensure alarm is cancelled if turned off
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('일정이 정상적으로 수정되었습니다')));
        Navigator.pop(context, true);
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('수정 실패: $error')));
      }
    }
  }

  void _removeAlarmIfSet() async {
    if (_startAlarm &&
        _alarmDate != null &&
        _alarmDate!.isAfter(DateTime.now())) {
      // 알람이 설정되어 있고 아직 실행되지 않았다면 삭제
      await alarmApi.deleteAlarm(widget.scheduleId);
    }
  }
}
