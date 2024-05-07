// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../screens/todo/todo_detail_screen.dart';

// class TodoListScreen extends ConsumerWidget {
//   const TodoListScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todoController = ref.read(todoControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('오늘의 To-Do 목록'),
//         automaticallyImplyLeading: false,
//       ),
//       body: FutureBuilder<List<Todo>>(
//         future: todoController.fetchTodosByDate(DateTime.now()),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('오류: ${snapshot.error.toString()}'));
//           } else if (snapshot.hasData) {
//             final todos = snapshot.data ?? [];
//             if (todos.isEmpty) {
//               return const Center(child: Text('오늘의 To-Do가 없습니다.'));
//             }
//             return ListView.builder(
//               itemCount: todos.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(todos[index].todoTitle),
//                   onTap: () {
//                     if (todos[index].id != null) {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return TodoDetailScreen(todoId: todos[index].id!);
//                         },
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                         content: Text('To-Do 아이템의 ID가 없습니다.'),
//                         duration: Duration(seconds: 2),
//                       ));
//                     }
//                   },
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('데이터가 없습니다.'));
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../provider/todo/todo_provider.dart';

// class TodoList extends ConsumerWidget {
//   const TodoList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todoController = ref.read(todoControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('오늘의 To-Do 목록'),
//         automaticallyImplyLeading: false,
//       ),
//       body: FutureBuilder<List<Todo>>(
//         future: todoController.fetchTodosByDate(DateTime.now()),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('오류: ${snapshot.error.toString()}'));
//           } else if (snapshot.hasData) {
//             final todos = snapshot.data ?? [];
//             if (todos.isEmpty) {
//               return const Center(child: Text('오늘의 To-Do가 없습니다.'));
//             } else {
//               return ListView.builder(
//                 itemCount: todos.length,
//                 itemBuilder: (context, index) {
//                   final todo = todos[index];
//                   return ListTile(
//                     title: Text(todo.todoTitle),
//                     trailing: Checkbox(
//                       value: todo.isCompleted,
//                       onChanged: (bool? newValue) async {
//                         if (newValue != null) {
//                           await todoController
//                               .updateTodo(todo.copyWith(isCompleted: newValue));
//                         }
//                       },
//                     ),
//                   );
//                 },
//               );
//             }
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../provider/todo/todo_provider.dart';

// class TodoList extends ConsumerStatefulWidget {
//   const TodoList({super.key});

//   @override
//   ConsumerState<TodoList> createState() => _TodoListState();
// }

// class _TodoListState extends ConsumerState<TodoList> {
//   List<Todo>? _todos;

//   void _fetchTodos() async {
//     final todoController = ref.read(todoControllerProvider);
//     var fetchedTodos = await todoController.fetchTodosByDate(DateTime.now());
//     setState(() {
//       _todos = fetchedTodos;
//     });
//   }

//   void _toggleTodoCompletion(Todo todo, bool isCompleted, int index) async {
//     final todoController = ref.read(todoControllerProvider);
//     // Update the local state immediately for a responsive UI
//     setState(() {
//       _todos![index] = todo.copyWith(isCompleted: isCompleted);
//     });
//     // Send the update to the server
//     await todoController.updateTodo(_todos![index]);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchTodos();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('오늘의 To-Do 목록'),
//         automaticallyImplyLeading: false,
//       ),
//       body: _todos == null
//           ? const Center(child: CircularProgressIndicator())
//           : _todos!.isEmpty
//               ? const Center(child: Text('오늘의 To-Do가 없습니다.'))
//               : ListView.builder(
//                   itemCount: _todos!.length,
//                   itemBuilder: (context, index) {
//                     final todo = _todos![index];
//                     return ListTile(
//                       title: Text(todo.todoTitle),
//                       trailing: Checkbox(
//                         value: todo.isCompleted,
//                         onChanged: (bool? newValue) {
//                           if (newValue != null) {
//                             _toggleTodoCompletion(todo, newValue, index);
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/todo/todo_model.dart';
import '../../controller/todo/todo_controller.dart';
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
