import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../screens/routine/routine_detail_screen.dart';
import '../../api/routine/routine_api.dart';
import '../../provider/routine/routine_provider.dart';

class RoutineListScreen extends ConsumerWidget {
  final routineApi = RoutineApi();
  RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routines = ref.watch(routineProvider);

    print('$routines list screens');
    final screenWidth = MediaQuery.of(context).size.width; //화면 크기 얻어오기
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        title: const Text(
          "루틴 리스트",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: routines.when(
        data: (data) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '루틴',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('${data.length}개',
                    style: const TextStyle(color: Colors.grey)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0), // 리스트 전체에 수직 패딩 추가
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
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 6.0),
                          color: const Color.fromARGB(255, 53, 74, 96),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoutineDetailScreen(
                                  routine: routine,
                                ),
                              ),
                            ),
                          child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.10,
                              padding:
                                  const EdgeInsets.all(15.0), // 카드 내부에 패딩 추가
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    routine.routineTitle,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    formatTimeOfDay(routine.startTime),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const RoutineCreateScreen(),
      //       ),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm(); // Use 'jm' for AM/PM format
  return format.format(dt);
}

// void showRoutineDetailModal(BuildContext context, WidgetRef ref,
//     Routine routine, RoutineApi routineApi) {
//   final TextEditingController titleController =
//       TextEditingController(text: routine.routineTitle);
//   final TextEditingController memoController =
//       TextEditingController(text: routine.memo);
//   TimeOfDay? selectedTime =
//       TimeOfDay(hour: routine.startTime.hour, minute: routine.startTime.minute);

//   List<bool> selectedDays = List.filled(7, false);
//   // 요일 설정 예: ["MON", "WED"] -> [false, true, false, true, false, false, false]
//   for (var day in routine.days) {
//     int dayIndex =
//         ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"].indexOf(day);
//     if (dayIndex != -1) selectedDays[dayIndex] = true;
//   }
//   String currentAlarmSound1 = routine.alarmSound;
//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: const Text("Routine Details"),
//             content: SizedBox(
//               width: 300, // 너비 조절
//               height: 550, // 높이 조절
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: titleController,
//                       decoration:
//                           const InputDecoration(labelText: "Routine Title"),
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         final TimeOfDay? pickedTime = await showTimePicker(
//                             context: context, initialTime: selectedTime!);
//                         if (pickedTime != null) {
//                           setState(() => selectedTime = pickedTime);
//                         }
//                       },
//                       child: Text("Time: ${selectedTime!.format(context)}"),
//                     ),
//                     ToggleButtons(
//                       isSelected: selectedDays,
//                       children: const [
//                         Text("SUN"),
//                         Text("MON"),
//                         Text("TUE"),
//                         Text("WED"),
//                         Text("THU"),
//                         Text("FRI"),
//                         Text("SAT")
//                       ],
//                       onPressed: (int index) {
//                         setState(
//                             () => selectedDays[index] = !selectedDays[index]);
//                       },
//                     ),
//                     DropdownButton<String>(
//                       value: currentAlarmSound1,
//                       onChanged: (String? newValue) {
//                         if (newValue != null) {
//                           setState(() => currentAlarmSound1 = newValue);
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
//                       decoration: const InputDecoration(labelText: "Memo"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('Cancel'),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               ElevatedButton(
//                   child: const Text("Save Changes"),
//                   onPressed: () async {
//                     final String routineTitle = titleController.text;
//                     final String memo = memoController.text;
//                     // TimeOfDay 객체에서 문자열 형식으로 시간 변환 (예: '07:30')
//                     final String startTime =
//                         "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
//                     // 선택된 요일들을 리스트로 변환
//                     final List<String?> days = selectedDays
//                         .asMap()
//                         .entries
//                         .map((entry) => entry.value
//                             ? [
//                                 "SUN",
//                                 "MON",
//                                 "TUE",
//                                 "WED",
//                                 "THU",
//                                 "FRI",
//                                 "SAT"
//                               ][entry.key]
//                             : null)
//                         .where((day) => day != null)
//                         .toList();

//                     try {
//                       // API 호출을 통해 서버에 데이터 업데이트 요청
//                       await routineApi.updateRoutine(
//                           routine.id, // 기존 루틴 ID
//                           routineTitle,
//                           startTime,
//                           days,
//                           currentAlarmSound1,
//                           memo);
//                       ref.refresh(routineProvider); // 리프레시로 변경사항 반영
//                       Navigator.pop(context); // 성공 시 다이얼로그 닫기
//                     } catch (error) {
//                       // 실패 시 오류 메시지 출력
//                       showDialog(
//                         context: context,
//                         builder: (context) => AlertDialog(
//                           title: const Text("Update Failed"),
//                           content: Text("Failed to update the routine: $error"),
//                           actions: <Widget>[
//                             TextButton(
//                               child: const Text('OK'),
//                               onPressed: () =>
//                                   Navigator.of(context).pop(), // 오류 다이얼로그 닫기
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   }),
//             ],
//           );
//         },
//       );
//     },
//   );
// }