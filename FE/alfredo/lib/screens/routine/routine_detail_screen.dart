import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/routine/routine_api.dart';
import '../../models/routine/routine_model.dart';
import '../../provider/routine/routine_provider.dart';

class RoutineDetailScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends ConsumerState<RoutineDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _memoController;
  TimeOfDay? _selectedTime;
  final List<bool> _selectedDays = List.filled(7, false);
  String _currentAlarmSound = 'Morning Glory';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.routine.routineTitle);
    _memoController = TextEditingController(text: widget.routine.memo);
    _selectedTime = TimeOfDay(
        hour: widget.routine.startTime.hour,
        minute: widget.routine.startTime.minute);
    _currentAlarmSound = widget.routine.alarmSound;

    for (var day in widget.routine.days) {
      int dayIndex =
          ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"].indexOf(day);
      if (dayIndex != -1) _selectedDays[dayIndex] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineApi = RoutineApi();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        title: const Text(
          "Routine Details",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Routine Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                      context: context, initialTime: _selectedTime!);
                  if (pickedTime != null) {
                    setState(() => _selectedTime = pickedTime);
                  }
                },
                child: Text("Time: ${_selectedTime!.format(context)}"),
              ),
              const SizedBox(height: 20),
              const Text("요일 설정"),
              ToggleButtons(
                isSelected: _selectedDays,
                children: const [
                  Text("SUN"),
                  Text("MON"),
                  Text("TUE"),
                  Text("WED"),
                  Text("THU"),
                  Text("FRI"),
                  Text("SAT"),
                ],
                onPressed: (int index) => setState(
                    () => _selectedDays[index] = !_selectedDays[index]),
              ),
              const SizedBox(height: 20),
              const Text("알람 설정"),
              DropdownButton<String>(
                value: _currentAlarmSound,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _currentAlarmSound = newValue);
                  }
                },
                items: <String>['Morning Glory', 'Beep Alarm', 'Digital Alarm']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _memoController,
                decoration: const InputDecoration(labelText: "Memo"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateRoutine,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateRoutine() async {
    if (_formKey.currentState!.validate()) {
      final String routineTitle = _titleController.text;
      final String memo = _memoController.text;
      final String startTime =
          "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

      final List<String?> days = _selectedDays
          .asMap()
          .entries
          .map((entry) => entry.value
              ? ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][entry.key]
              : null)
          .where((day) => day != null)
          .toList();

      try {
        await RoutineApi().updateRoutine(
          widget.routine.id,
          routineTitle,
          startTime,
          days,
          _currentAlarmSound,
          memo,
        );
        ref.refresh(routineProvider);
        Navigator.pop(context);
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Update Failed"),
            content: Text("Failed to update the routine: $error"),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }
}
