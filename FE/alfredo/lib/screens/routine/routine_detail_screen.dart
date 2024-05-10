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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        title: const Text(
          "루틴 상세 보기",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "루틴 제목"),
              maxLines: null,
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
              child: Text("시간: ${_selectedTime!.format(context)}"),
            ),
            const SizedBox(height: 20),
            const Text("요일 설정"),
            ToggleButtons(
              isSelected: _selectedDays,
              children: const [
                Text("일"),
                Text("월"),
                Text("화"),
                Text("수"),
                Text("목"),
                Text("금"),
                Text("토"),
              ],
              onPressed: (int index) =>
                  setState(() => _selectedDays[index] = !_selectedDays[index]),
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
              decoration: const InputDecoration(labelText: "메모"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateRoutine,
              child: const Text("수정하기"),
            ),
          ],
        ),
      ),
    );
  }

  void _updateRoutine() async {
    if (_titleController.text.isEmpty) {
      // 제목 필드가 비어 있는 경우 경고 메시지를 표시하고 작업을 중단합니다.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("경고"),
          content: const Text("루틴 제목을 입력해주세요"),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
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
            title: const Text("수정 실패"),
            content: Text("루틴 수정에 실패했습니다.: $error"),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }
}
