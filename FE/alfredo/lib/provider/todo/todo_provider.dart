import '../../models/todo/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/todo/todo_controller.dart';

final todoControllerProvider = Provider<TodoController>((ref) {
  return TodoController(ref);
});

// final todoProvider = FutureProvider.family<Todo, int>((ref, todoId) async {
//   return ref.read(todoControllerProvider).getTodoDetail(todoId);
// });
