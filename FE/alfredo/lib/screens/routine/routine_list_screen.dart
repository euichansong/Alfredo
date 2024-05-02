import 'package:flutter/material.dart';

import '../../models/routine/routine_model.dart';

class RoutineListScreen extends StatelessWidget {
  const RoutineListScreen({super.key});
  // final Future<List<RoutineModel>> routines = RoutineApi.getAllRoutines();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Routine",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: const Center(
        child: Text("Tap the button below!"),
      ),
      // body: FutureBuilder(
      //   future: routines,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasData) {
      //         return Column(
      //           children: [
      //             const SizedBox(height: 50),
      //             Expanded(child: makeList(snapshot)),
      //           ],
      //         );
      //       } else if (snapshot.hasError) {
      //         return Center(child: Text("Error: ${snapshot.error}"));
      //       }
      //     }
      //     return const Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 버튼이 눌렸을 때 실행할 코드
          showRoutineCreateDialog(context);
          print("Floating Action Button Tapped!");
        },
        icon: const Icon(Icons.add), // 버튼 앞에 위치할 아이콘
        label: const Text("Add"), // 버튼의 라벨
        backgroundColor: Colors.purple, // 버튼의 배경색
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<RoutineModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        // print(index);
        var routine = snapshot.data![index];
        // print(routine);
        return Column(children: [Text(routine.routineTitle)]);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }

  void showRoutineCreateDialog(BuildContext context) {
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
              content: SingleChildScrollView(
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
                    ToggleButtons(
                      isSelected: selectedDays,
                      children: const [
                        Text("일"),
                        Text("월"),
                        Text("화"),
                        Text("수"),
                        Text("목"),
                        Text("금"),
                        Text("토")
                      ],
                      onPressed: (int index) {
                        setState(
                            () => selectedDays[index] = !selectedDays[index]);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text("알람 설정"),
                    DropdownButton<String>(
                      value: "Morning Glory",
                      items: const [
                        DropdownMenuItem(
                            value: "Morning Glory",
                            child: Text("Morning Glory")),
                        // 여기에 추가 아이템을 넣을 수 있습니다.
                      ],
                      onChanged: (value) => {}, // 선택된 아이템에 따른 로직 추가
                    ),
                    TextField(
                      controller: memoController,
                      decoration: const InputDecoration(labelText: "메모"),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    // 데이터 처리 로직 추가
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
