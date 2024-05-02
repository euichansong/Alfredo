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
      _place = schedule.place;
      setState(() {}); // Trigger a rebuild after loading data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load schedule details: $e')));
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
      appBar: AppBar(title: const Text("일정 상세")),
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
        controller: _titleController!,
        decoration: const InputDecoration(labelText: '일정 제목'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '제목을 입력해주세요';
          }
          return null;
        },
      ),
      ListTile(
        title: Text("시작 날짜: ${DateFormat('yyyy-MM-dd').format(_startDate)}"),
        onTap: () => _selectDate(context, isStart: true),
      ),
      ListTile(
        title: Text(
            "종료 날짜: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '선택되지 않음'}"),
        onTap: () => _selectDate(context, isStart: false),
      ),
      SwitchListTile(
        title: const Text('알람 사용'),
        value: _startAlarm,
        onChanged: (bool value) => setState(() => _startAlarm = value),
      ),
      SwitchListTile(
        title: const Text('하루 종일'),
        value: _withTime,
        onChanged: (bool value) => setState(() {
          _withTime = value;
          if (!value) {
            _startTime = null;
            _endTime = null;
          }
        }),
      ),
      if (!_withTime) ...[
        ListTile(
          title: Text(
              '시작 시간: ${_startTime != null ? _startTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: true),
        ),
        ListTile(
          title: Text(
              '종료 시간: ${_endTime != null ? _endTime!.format(context) : "선택되지 않음"}'),
          onTap: () => _selectTime(context, isStart: false),
        ),
      ],
      TextFormField(
        initialValue: _place,
        decoration: const InputDecoration(labelText: '장소'),
        onSaved: (value) => _place = value,
      ),
      ElevatedButton(
        onPressed: _updateSchedule,
        child: const Text('수정'),
      ),
    ];
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
          // 수정 성공 후 리스트를 새로 고침하기 위해 결과로 true를 반환
          Navigator.pop(context, true);
        }).catchError((error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Update failed: $error')));
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating schedule: $e')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
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
      initialTime:
          isStart ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
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
}
