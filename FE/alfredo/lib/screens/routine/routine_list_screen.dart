import 'package:flutter/material.dart';

import '../../api/routine/routine_api.dart';
import '../../models/routine/routine_model.dart';

class RoutineListScreen extends StatelessWidget {
  RoutineListScreen({super.key});
  final Future<List<RoutineModel>> routines = RoutineApi.getAllRoutines();

  @override
  Widget build(BuildContext context) {
    // print(routines);
    // print(isLoading);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Routine",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: FutureBuilder(
        future: routines,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                print(index);
                var routine = snapshot.data![index];
                return Text(routine.routineTitle);
              },
              separatorBuilder: (context, index) => SizedBox(height: 20),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
