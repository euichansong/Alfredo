import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/todo/todo_model.dart';
import '../../provider/todo/todo_provider.dart';
import '../../screens/todo/todo_detail_screen.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({super.key});

  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList> {
  List<Todo>? _todos;

  void _fetchTodos() async {
    final todoController = ref.read(todoControllerProvider);
    var fetchedTodos = await todoController.fetchTodosByDate(DateTime.now());
    setState(() {
      _todos = fetchedTodos;
    });
  }

  void _toggleTodoCompletion(Todo todo, bool isCompleted, int index) async {
    final todoController = ref.read(todoControllerProvider);
    // Update the local state immediately for a responsive UI
    setState(() {
      _todos![index] = todo.copyWith(isCompleted: isCompleted);
    });
    // Send the update to the server
    await todoController.updateTodo(_todos![index]);
  }

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 To-Do 목록'),
        automaticallyImplyLeading: false,
      ),
      body: _todos == null
          ? const Center(child: CircularProgressIndicator())
          : _todos!.isEmpty
              ? const Center(child: Text('오늘의 To-Do가 없습니다.'))
              : ListView.builder(
                  itemCount: _todos!.length,
                  itemBuilder: (context, index) {
                    final todo = _todos![index];
                    return ListTile(
                      title: Text(todo.todoTitle),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TodoDetailScreen(todoId: todo.id!);
                          },
                        );
                      },
                      trailing: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            _toggleTodoCompletion(todo, newValue, index);
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
