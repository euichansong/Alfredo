import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../api/routine/routine_api.dart';
import '../../models/routine/routine_model.dart';
import '../../provider/routine/routine_provider.dart';
import 'routine_create_screen.dart';

class RoutineListScreen extends ConsumerWidget {
  final routineApi = RoutineApi();
  RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider);

    print('$routines list screens');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Routine List",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: routines.when(
        data: (data) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Routines',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('${data.length} Routines',
                    style: const TextStyle(color: Colors.grey)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final routine = data[index];
                    return Dismissible(
                      key: Key(routine.id
                          .toString()), // Provide a unique key for each item
                      background: Container(
                        color: Colors.red,
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      onDismissed: (direction) async {
                        await routineApi.deleteRoutine(routine.id);
                        // ref.refresh(routineProvider);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(routine.routineTitle),
                          trailing: Text(formatTimeOfDay(routine.startTime)),
                          onTap: () => showRoutineDetailModal(
                              context, ref, routine, routineApi),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RoutineCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); // Use 'jm' for AM/PM format
  return format.format(dt);
}

// void showRoutineCreateModal(BuildContext context, WidgetRef ref) {
//   print('버튼 눌림');
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController memoController = TextEditingController();
//   final RoutineApi routineApi = RoutineApi();
//   TimeOfDay? selectedTime = const TimeOfDay(hour: 7, minute: 30); // 초기 시간 설정
//   List<bool> selectedDays = List.filled(7, false); // 요일 선택
//   String currentAlarmSound = "Morning Glory";

//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Routine 추가"),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             content: SizedBox(
//               width: 300, // 너비 조절
//               height: 550, // 높이 조절
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: titleController,
//                       decoration:
//                           const InputDecoration(labelText: "Routine 제목"),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text("시간"),
//                         GestureDetector(
//                           onTap: () async {
//                             final TimeOfDay? pickedTime = await showTimePicker(
//                                 context: context, initialTime: selectedTime!);
//                             if (pickedTime != null) {
//                               setState(() => selectedTime = pickedTime);
//                             }
//                           },
//                           child: Text(selectedTime!.format(context)),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     const Text("요일 설정"),
//                     SizedBox(
//                       width: 200,
//                       child: ToggleButtons(
//                         isSelected: selectedDays,
//                         children: const [
//                           Text("일"),
//                           Text("월"),
//                           Text("화"),
//                           Text("수"),
//                           Text("목"),
//                           Text("금"),
//                           Text("토"),
//                         ],
//                         onPressed: (int index) => setState(
//                             () => selectedDays[index] = !selectedDays[index]),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text("알람 설정"),
//                     DropdownButton<String>(
//                       value: currentAlarmSound, // 현재 선택된 알람 사운드
//                       onChanged: (String? newValue) {
//                         if (newValue != null) {
//                           setState(() => currentAlarmSound = newValue);
//                         }
//                       },
//                       items: <String>[
//                         'Morning Glory',
//                         'Beep Alarm',
//                         'Digital Alarm'
//                       ].map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     TextField(
//                       controller: memoController,
//                       decoration: const InputDecoration(labelText: "메모"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               ElevatedButton(
//                 onPressed: () async {
//                   final String? idToken =
//                       await ref.watch(authManagerProvider.future);
//                   final routineTitle = titleController.text;
//                   // final startTime = selectedTime!.format(context);
//                   final hour = selectedTime!.hour.toString().padLeft(2, '0');
//                   final minute =
//                       selectedTime!.minute.toString().padLeft(2, '0');

//                   final startTime = '$hour:$minute:00';
//                   final days = selectedDays
//                       .asMap()
//                       .entries
//                       .map((e) => e.value
//                           ? [
//                               "SUN",
//                               "MON",
//                               "TUE",
//                               "WED",
//                               "THU",
//                               "FRI",
//                               "SAT"
//                             ][e.key]
//                           : "")
//                       .where((d) => d.isNotEmpty)
//                       .toList();

//                   final memo = memoController.text;

//                   await routineApi.createRoutine(idToken, routineTitle,
//                       startTime, days, currentAlarmSound, memo);
//                   //다시 불러오기
//                   ref.refresh(routineProvider);
//                   print('여기오니');

//                   Navigator.pop(context);
//                 },
//                 child: const Text("저장"),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

void showRoutineDetailModal(BuildContext context, WidgetRef ref,
    Routine routine, RoutineApi routineApi) {
  final TextEditingController titleController =
      TextEditingController(text: routine.routineTitle);
  final TextEditingController memoController =
      TextEditingController(text: routine.memo);
  TimeOfDay? selectedTime =
      TimeOfDay(hour: routine.startTime.hour, minute: routine.startTime.minute);

  List<bool> selectedDays = List.filled(7, false);
  // 요일 설정 예: ["MON", "WED"] -> [false, true, false, true, false, false, false]
  for (var day in routine.days) {
    int dayIndex =
        ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"].indexOf(day);
    if (dayIndex != -1) selectedDays[dayIndex] = true;
  }
  String currentAlarmSound1 = routine.alarmSound;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Routine Details"),
            content: SizedBox(
              width: 300, // 너비 조절
              height: 550, // 높이 조절
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration:
                          const InputDecoration(labelText: "Routine Title"),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: selectedTime!);
                        if (pickedTime != null) {
                          setState(() => selectedTime = pickedTime);
                        }
                      },
                      child: Text("Time: ${selectedTime!.format(context)}"),
                    ),
                    ToggleButtons(
                      isSelected: selectedDays,
                      children: const [
                        Text("SUN"),
                        Text("MON"),
                        Text("TUE"),
                        Text("WED"),
                        Text("THU"),
                        Text("FRI"),
                        Text("SAT")
                      ],
                      onPressed: (int index) {
                        setState(
                            () => selectedDays[index] = !selectedDays[index]);
                      },
                    ),
                    DropdownButton<String>(
                      value: currentAlarmSound1,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() => currentAlarmSound1 = newValue);
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
                      decoration: const InputDecoration(labelText: "Memo"),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: const Text("Save Changes"),
                  onPressed: () async {
                    final String routineTitle = titleController.text;
                    final String memo = memoController.text;
                    // TimeOfDay 객체에서 문자열 형식으로 시간 변환 (예: '07:30')
                    final String startTime =
                        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
                    // 선택된 요일들을 리스트로 변환
                    final List<String?> days = selectedDays
                        .asMap()
                        .entries
                        .map((entry) => entry.value
                            ? [
                                "SUN",
                                "MON",
                                "TUE",
                                "WED",
                                "THU",
                                "FRI",
                                "SAT"
                              ][entry.key]
                            : null)
                        .where((day) => day != null)
                        .toList();

                    try {
                      // API 호출을 통해 서버에 데이터 업데이트 요청
                      await routineApi.updateRoutine(
                          routine.id, // 기존 루틴 ID
                          routineTitle,
                          startTime,
                          days,
                          currentAlarmSound1,
                          memo);
                      ref.refresh(routineProvider); // 리프레시로 변경사항 반영
                      Navigator.pop(context); // 성공 시 다이얼로그 닫기
                    } catch (error) {
                      // 실패 시 오류 메시지 출력
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Update Failed"),
                          content: Text("Failed to update the routine: $error"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () =>
                                  Navigator.of(context).pop(), // 오류 다이얼로그 닫기
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ],
          );
        },
      );
    },
  );
}
