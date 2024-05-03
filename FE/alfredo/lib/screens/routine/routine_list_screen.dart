import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/routine/routine_model.dart';
import '../../provider/routine/routine_provider.dart';

class RoutineListScreen extends ConsumerWidget {
  const RoutineListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesFuture =
        ref.read(routineControllerProvider).getAllRoutines(ref);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Routine List",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: FutureBuilder<List<RoutineModel>>(
        future: routinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Expanded(child: makeList(snapshot)),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRoutineCreateModal(context, ref), // ref를 전달
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<RoutineModel>> snapshot) {
    return ListView.separated(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        var routine = snapshot.data![index];
        return Column(children: [Text(routine.routineTitle)]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  void showRoutineCreateModal(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController memoController = TextEditingController();
    TimeOfDay? selectedTime = const TimeOfDay(hour: 7, minute: 30); // 초기 시간 설정

    List<bool> selectedDays = List.filled(7, false); // 요일 선택

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime!);
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
                      ToggleButtons(
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
                      const SizedBox(height: 10),
                      const Text("알람 설정"),
                      DropdownButton<String>(
                        value: "Morning Glory",
                        items: const [
                          DropdownMenuItem(
                            value: "Morning Glory",
                            child: Text("Morning Glory"),
                          ),
                        ],
                        onChanged: (value) => {},
                      ),
                      TextField(
                        controller: memoController,
                        decoration: const InputDecoration(labelText: "메모"),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
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
                    const alarmSound = "Morning Glory";
                    final memo = memoController.text;

                    await ref.read(routineControllerProvider).createRoutine(
                        ref, routineTitle, startTime, days, alarmSound, memo);

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
}
