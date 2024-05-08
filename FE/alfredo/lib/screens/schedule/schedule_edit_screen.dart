import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';
import '../../provider/schedule/schedule_provider.dart';

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
  int? _selectedAlarmOption; // 선택된 알람 옵션 인덱스
  String? _place;

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
      appBar: AppBar(title: const Text("일정 수정")),
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
        decoration: const InputDecoration(
            labelText: '일정 제목', border: OutlineInputBorder()),
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
              _alarmTime = null;
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
      if (!_withTime) ...[
        ListTile(
          leading: const Icon(Icons.access_time),
          title: Text(
              '시작 시간: ${_startTime != null ? _startTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: true),
        ),
        ListTile(
          leading: const Icon(Icons.access_time_filled),
          title: Text(
              '종료 시간: ${_endTime != null ? _endTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: false),
        ),
      ],
      TextFormField(
        initialValue: _place,
        decoration: const InputDecoration(
            labelText: '장소', border: OutlineInputBorder()),
        onSaved: (value) => _place = value,
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: _updateSchedule,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
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
                    _updateAlarmTime(index);
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

  TimeOfDay _calculateStartTime(double hoursBefore) {
    DateTime baseDateTime = _startDate;
    if (!_withTime && _startTime != null) {
      baseDateTime = DateTime(_startDate.year, _startDate.month, _startDate.day,
          _startTime!.hour, _startTime!.minute);
      int minutesToSubtract = (hoursBefore * 60).round();
      baseDateTime =
          baseDateTime.subtract(Duration(minutes: minutesToSubtract));
    }
    return TimeOfDay.fromDateTime(baseDateTime);
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
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

  Future<void> _selectTime(BuildContext context,
      {required bool isStart}) async {
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

  void _updateSchedule() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var updatedSchedule = Schedule(
        scheduleId: widget.scheduleId,
        scheduleTitle: _titleController!.text,
        startDate: _startDate,
        endDate: _endDate,
        startAlarm: _startAlarm,
        alarmTime: _alarmTime,
        place: _place,
        startTime: _startTime,
        endTime: _endTime,
        withTime: _withTime,
      );
      try {
        ref
            .read(scheduleControllerProvider)
            .updateSchedule(updatedSchedule.scheduleId!, updatedSchedule)
            .then((_) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('일정이 정상적으로 수정되었습니다')));
          Navigator.pop(context, true);
        }).catchError((error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('수정 실패: $error')));
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('일정 수정 중 오류 발생: $e')));
      }
    }
  }
}
