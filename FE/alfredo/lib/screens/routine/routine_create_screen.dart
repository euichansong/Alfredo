// import 'package:flutter/material.dart';

// class RoutineCreateScreen extends StatelessWidget {
//   const RoutineCreateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           "RoutineList",
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/routine/routine_api.dart';
import '../../provider/routine/routine_provider.dart';
import '../../provider/user/future_provider.dart';

void showRoutineCreateModal(BuildContext context, WidgetRef ref) {
  print('버튼 눌림');
  final TextEditingController titleController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final RoutineApi routineApi = RoutineApi();
  TimeOfDay? selectedTime = const TimeOfDay(hour: 7, minute: 30); // 초기 시간 설정
  List<bool> selectedDays = List.filled(7, false); // 요일 선택
  String currentAlarmSound = "Morning Glory";

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, //x와의 간격 유지를 위해 필요
              children: [
                const Text("Routine 추가"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            content: SizedBox(
              width: 300, // 너비 조절
              height: 550, // 높이 조절
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(labelText: "Routine 제목"),
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
                      width: 200,
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
                      value: currentAlarmSound, // 현재 선택된 알람 사운드
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => currentAlarmSound = newValue);
                        }
                      },
                      items: <String>[
                        'Morning Glory',
                        'Beep Alarm',
                        'Digital Alarm'
                      ].map<DropdownMenuItem<String>>((String value) {
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
                  ], //column의 children 끝
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final String? idToken =
                      await ref.watch(authManagerProvider.future);
                  final routineTitle = titleController.text;
                  // final startTime = selectedTime!.format(context);
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
                  //다시 불러오기
                  ref.refresh(routineProvider);
                  print('여기오니');

                  Navigator.pop(context);
                },
                child: const Text("저장"),
              ),
            ],
          );
        },
      );
    },
  );
}
