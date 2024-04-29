import 'package:flutter/material.dart';

import '../../api/routine/routine_api.dart';
import '../../models/routine/routine_model.dart';

class RoutineListScreen extends StatelessWidget {
  RoutineListScreen({super.key});
  Future<List<RoutineModel>> routines = RoutineApi.getAllRoutines();

  @override
  Widget build(BuildContext context) {
    print(routines);
    // print(isLoading);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Routine",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
