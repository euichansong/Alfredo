import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../controller/schedule/schedule_controller.dart';
import '../../models/schedule/schedule_model.dart';

class ScheduleEditScreen extends StatefulWidget {
  final int scheduleId;

  const ScheduleEditScreen({super.key, required this.scheduleId});

  @override
  _ScheduleEditScreenState createState() => _ScheduleEditScreenState();
}

class _ScheduleEditScreenState extends State<ScheduleEditScreen> {
  final ScheduleController controller = ScheduleController();
  final _formKey = GlobalKey<FormState>();

  late String _scheduleTitle;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _startAlarm;
  late bool _withTime;
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
      var schedule = await controller.getScheduleDetail(widget.scheduleId);
      setState(() {
        _scheduleTitle = schedule.scheduleTitle;
        _startDate = schedule.startDate;
        _endDate = schedule.endDate;
        _startAlarm = schedule.startAlarm;
        _withTime = schedule.withTime;
        _startTime = schedule.startTime;
        _endTime = schedule.endTime;
        _place = schedule.place;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load schedule details: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Schedule"),
      ),
      body: _formKey.currentState == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    initialValue: _scheduleTitle,
                    decoration:
                        const InputDecoration(labelText: 'Schedule Title'),
                    onSaved: (value) => _scheduleTitle = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter the title'
                        : null,
                  ),
                  ListTile(
                    title: Text(
                        "Start Date: ${DateFormat('yyyy-MM-dd').format(_startDate)}"),
                    onTap: () => _selectDate(context, isStart: true),
                  ),
                  ListTile(
                    title: Text(
                        "End Date: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'Not set'}"),
                    onTap: () => _selectDate(context, isStart: false),
                  ),
                  SwitchListTile(
                    title: const Text('Use Alarm'),
                    value: _startAlarm,
                    onChanged: (bool value) =>
                        setState(() => _startAlarm = value),
                  ),
                  SwitchListTile(
                    title: const Text('All Day'),
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
                          'Start Time: ${_startTime != null ? _startTime!.format(context) : "Not set"}'),
                      onTap: () => _selectTime(context, isStart: true),
                    ),
                    ListTile(
                      title: Text(
                          'End Time: ${_endTime != null ? _endTime!.format(context) : "Not set"}'),
                      onTap: () => _selectTime(context, isStart: false),
                    ),
                  ],
                  ElevatedButton(
                    onPressed: _updateSchedule,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
    );
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

  void _updateSchedule() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var updatedSchedule = Schedule(
        scheduleId: widget.scheduleId,
        scheduleTitle: _scheduleTitle,
        startDate: _startDate,
        endDate: _endDate,
        startAlarm: _startAlarm,
        place: _place,
        startTime: _startTime,
        endTime: _endTime,
        withTime: _withTime,
      );
      controller.updateSchedule(widget.scheduleId, updatedSchedule).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Update failed: $error')));
      });
    }
  }
}
