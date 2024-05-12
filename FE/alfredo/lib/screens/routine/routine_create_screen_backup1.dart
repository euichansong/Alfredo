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
  List<bool> selectedDays = [false, true, true, true, true, true, false];
  String currentAlarmSound = "Morning Glory";

  _RoutineCreateScreenState({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2338),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "루틴 생성",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "루틴 제목",
                  labelStyle: TextStyle(fontSize: 18),
                  focusColor: Color(0xFF0D2338),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF0D2338)), // 네이비 색 테두리
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '루틴 제목을 입력해주세요';
                  }
                  return null;
                },
                maxLines: null,
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "시간",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16.0), // 원하는 margin 설정
                    child: GestureDetector(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                            context: context, initialTime: selectedTime!);
                        if (pickedTime != null) {
                          setState(() => selectedTime = pickedTime);
                        }
                      },
                      child: Text(
                        selectedTime!.format(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              // const Text(
              //   "요일 설정",
              //   style: TextStyle(fontSize: 18),
              // ),
              SizedBox(
                child: ToggleButtons(
                  isSelected: selectedDays,
                  selectedColor: Colors.white, // 선택된 항목의 텍스트 색상
                  color: Colors.black, // 선택되지 않은 항목의 텍스트 색상
                  fillColor: const Color(0xFF0D2338), // 선택된 항목의 배경색
                  selectedBorderColor:
                      const Color(0xFF0D2338), // 선택된 항목의 테두리 색상
                  borderColor: Colors.grey, // 선택되지 않은 항목의 테두리 색상
                  borderWidth: 1.0,
                  borderRadius: BorderRadius.circular(0.0), // 테두리 모서리 둥글기
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
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "알람 설정",
                    style: TextStyle(fontSize: 18),
                  ),
                  DropdownButton<String>(
                    value: currentAlarmSound,
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
                ],
              ),
              const SizedBox(height: 50),
              TextField(
                controller: memoController,
                decoration: const InputDecoration(
                  labelText: "메모",
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0), // 텍스트 필드 내부 패딩 설정
                ),
                style: const TextStyle(fontSize: 18), // 입력 텍스트 크기 설정
                maxLines: null, // 줄바꿈 허용
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity, // 버튼의 가로 크기를 전체로 설정
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
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
                      final String? idToken =
                          await ref.watch(authManagerProvider.future);
                      final routineTitle = titleController.text;
                      final hour =
                          selectedTime!.hour.toString().padLeft(2, '0');
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

                      // await routineApi.createRoutine(idToken, routineTitle,
                      //     startTime, days, currentAlarmSound, memo);
                      ref.refresh(routineProvider);

                      Navigator.pop(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => RoutineListScreen(),
                      //   ),
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D2338), // 버튼 배경색
                    foregroundColor: Colors.white, // 버튼 텍스트 색
                  ),
                  child: const Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
