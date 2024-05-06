import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/todo/todo_controller.dart';
import '../../models/todo/todo_model.dart';
import '../../provider/todo/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the TodoController from the provider
    final todoController = ref.read(todoControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List for Today'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController
            .fetchTodosByDate(DateTime.now()), // Fetch todos for today's date
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            final todos = snapshot.data ?? [];
            if (todos.isEmpty) {
              return const Center(child: Text('No To-Dos for today.'));
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                // Display each todoTitle in a list tile
                return ListTile(
                  title: Text(todos[index].todoTitle),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }
}
