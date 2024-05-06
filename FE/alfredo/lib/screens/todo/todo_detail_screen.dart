// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../provider/todo/todo_provider.dart';

// class TodoDetailScreen extends ConsumerWidget {
//   final int todoId;

//   const TodoDetailScreen({super.key, required this.todoId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todo = ref.watch(todoProvider(
//         todoId)); // Assuming todoProvider is a provider that fetches a Todo by id

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Todo Details'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to TodoEditScreen
//               Navigator.pushNamed(context, '/edit-todo', arguments: todoId);
//             },
//           ),
//           // IconButton(
//           //   icon: const Icon(Icons.delete),
//           //   onPressed: () {
//           //     // Handle Todo deletion
//           //     _deleteTodo(context, ref, todoId);
//           //   },
//           // ),
//         ],
//       ),
//       body: todo.when(
//         data: (todo) => _buildTodoDetails(todo),
//         loading: () => const CircularProgressIndicator(),
//         error: (err, stack) => Text('Error: $err'),
//       ),
//     );
//   }

//   Widget _buildTodoDetails(Todo todo) {
//     return ListView(
//       children: [
//         ListTile(
//           title: const Text('Title'),
//           subtitle: Text(todo.todoTitle),
//         ),
//         ListTile(
//           title: const Text('Content'),
//           subtitle: Text(todo.todoContent ?? 'No content provided'),
//         ),
//         ListTile(
//           title: const Text('Due Date'),
//           subtitle: Text(DateFormat('yyyy-MM-dd').format(todo.dueDate)),
//         ),
//         ListTile(
//           title: const Text('Spent Time'),
//           subtitle: Text('${todo.spentTime ?? 'Not specified'} minutes'),
//         ),
//         ListTile(
//           title: const Text('Is Completed'),
//           subtitle: Text(todo.isCompleted ? 'Yes' : 'No'),
//         ),
//         ListTile(
//           title: const Text('URL'),
//           subtitle: Text(todo.url ?? 'No URL provided'),
//         ),
//         ListTile(
//           title: const Text('Place'),
//           subtitle: Text(todo.place ?? 'No place specified'),
//         ),
//         ListTile(
//           title: const Text('SubIndex'),
//           subtitle: Text(todo.subIndex ?? 'No subIndex'),
//         ),
//       ],
//     );
//   }

//   void _deleteTodo(BuildContext context, WidgetRef ref, int todoId) {
//     ref.read(todoControllerProvider).deleteTodo(todoId).then((_) {
//       Navigator.pop(context);
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Todo deleted successfully')));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to delete todo: $error')));
//     });
//   }
// }
