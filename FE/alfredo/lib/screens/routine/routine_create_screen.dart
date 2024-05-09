import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/routine/routine_api.dart';
import '../../provider/routine/routine_provider.dart';
import '../../provider/user/future_provider.dart';

class RoutineCreateScreen extends ConsumerWidget {
  const RoutineCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RoutineCreateScreenBody(ref: ref);
  }
}

class _RoutineCreateScreenBody extends StatefulWidget {
  final WidgetRef ref;

  const _RoutineCreateScreenBody({super.key, required this.ref});

  @override
  _RoutineCreateScreenState createState() =>
      _RoutineCreateScreenState(ref: ref);
}

class _RoutineCreateScreenState extends State<_RoutineCreateScreenBody> {
  final WidgetRef ref;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final RoutineApi routineApi = RoutineApi();
  TimeOfDay? selectedTime = const TimeOfDay(hour: 7, minute: 30);
  List<bool> selectedDays = List.filled(7, false);
  String currentAlarmSound = "Morning Glory";

  _RoutineCreateScreenState({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        title: const Text(
          "Routine 추가",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SizedBox(
        width: 300,
        height: 550,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Routine 제목"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("시간"),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                          context: context, initialTime: selectedTime!);
                      if (pickedTime != null) {
                        setState(() => selectedTime = pickedTime);
                      }
                    },
                    child: Text(selectedTime!.format(context)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("요일 설정"),
              SizedBox(
                width: 300,
                child: ToggleButtons(
                  isSelected: selectedDays,
                  children: const [
                    Text("일"),
                    Text("월"),
                    Text("화"),
                    Text("수"),
                    Text("목"),
                    Text("금"),
                    Text("토"),
                  ],
                  onPressed: (int index) => setState(
                      () => selectedDays[index] = !selectedDays[index]),
                ),
              ),
              const SizedBox(height: 10),
              const Text("알람 설정"),
              DropdownButton<String>(
                value: currentAlarmSound,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => currentAlarmSound = newValue);
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
              TextField(
                controller: memoController,
                decoration: const InputDecoration(labelText: "메모"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String? idToken =
                      await ref.watch(authManagerProvider.future);
                  final routineTitle = titleController.text;
                  final hour = selectedTime!.hour.toString().padLeft(2, '0');
                  final minute =
                      selectedTime!.minute.toString().padLeft(2, '0');

                  final startTime = '$hour:$minute:00';
                  final days = selectedDays
                      .asMap()
                      .entries
                      .map((e) => e.value
                          ? [
                              "SUN",
                              "MON",
                              "TUE",
                              "WED",
                              "THU",
                              "FRI",
                              "SAT"
                            ][e.key]
                          : "")
                      .where((d) => d.isNotEmpty)
                      .toList();

                  final memo = memoController.text;

                  await routineApi.createRoutine(idToken, routineTitle,
                      startTime, days, currentAlarmSound, memo);
                  ref.refresh(routineProvider);

                  Navigator.pop(context);
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => RoutineListScreen(),
                  //   ),
                  // );
                },
                child: const Text("저장"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
