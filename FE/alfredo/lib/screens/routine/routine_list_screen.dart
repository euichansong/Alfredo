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
    final TextEditingController alarmSoundController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Routine"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Routine Title"),
              ),
              TextField(
                controller: alarmSoundController,
                decoration: const InputDecoration(labelText: "Alarm Sound"),
              ),
              // 추가 입력 필드를 여기에 추가할 수 있습니다.
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 모달 닫기
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // await createRoutine(
                //     titleController.text, alarmSoundController.text);
                Navigator.pop(context); // 모달 닫기
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
