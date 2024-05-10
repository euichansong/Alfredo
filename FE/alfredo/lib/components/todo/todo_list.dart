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

  @override
  void initState() {
    super.initState();
    _fetchTodos(); // 처음 위젯 로드 시 데이터를 불러옵니다.
  }

  void _onTodoUpdated() {
    _fetchTodos(); // 할 일이 업데이트 될 때 데이터를 다시 불러옵니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('오늘의 할 일 목록',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Georgia',
                  color: Color.fromARGB(255, 242, 237, 237))),
        ),
      ),
      body: _todos == null
          ? const Center(child: CircularProgressIndicator())
          : _todos!.isEmpty
              ? const Center(child: Text('오늘의 할 일이 없습니다.'))
              : ListView.builder(
                  itemCount: _todos!.length,
                  itemBuilder: (context, index) {
                    final todo = _todos![index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8.0),
                      title: Text(
                        todo.todoTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 8, 1, 1),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TodoDetailScreen(todoId: todo.id!);
                          },
                        ).then(
                            (_) => _onTodoUpdated()); // 대화 상자가 닫힌 후 데이터를 갱신합니다.
                      },
                      trailing: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              _toggleTodoCompletion(todo, newValue, index);
                            }
                          },
                          activeColor: const Color(0xFFc5a880),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _toggleTodoCompletion(Todo todo, bool isCompleted, int index) async {
    final todoController = ref.read(todoControllerProvider);
    setState(() {
      _todos![index] = todo.copyWith(isCompleted: isCompleted);
    });
    await todoController
        .updateTodo(_todos![index])
        .then((_) => _onTodoUpdated());
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../screens/todo/todo_detail_screen.dart';

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
//     setState(() {
//       _todos![index] = todo.copyWith(isCompleted: isCompleted);
//     });
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
//       backgroundColor: Colors.transparent, // Scaffold 배경을 투명하게 설정
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(40.0), // AppBar의 높이 설정
//         child: AppBar(
//           backgroundColor: Colors.transparent, // AppBar 배경을 투명하게 설정
//           elevation: 0, // AppBar의 그림자 제거
//           centerTitle: true,
//           title: const Text('오늘의 할 일 목록',
//               style: TextStyle(
//                   fontSize: 20.0,
//                   fontFamily: 'Georgia',
//                   color: Color.fromARGB(255, 242, 237, 237))),
//         ),
//       ),
//       body: _todos == null
//           ? const Center(child: CircularProgressIndicator())
//           : _todos!.isEmpty
//               ? const Center(child: Text('오늘의 할 일이 없습니다.'))
//               : ListView.builder(
//                   itemCount: _todos!.length,
//                   itemBuilder: (context, index) {
//                     final todo = _todos![index];
//                     return ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 30.0, vertical: 8.0), // 패딩 조정
//                       title: Text(
//                         todo.todoTitle,
//                         style: const TextStyle(
//                           fontSize: 18,
//                           color: Color.fromARGB(255, 8, 1, 1),
//                         ),
//                       ),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return TodoDetailScreen(todoId: todo.id!);
//                           },
//                         );
//                       },
//                       trailing: Transform.scale(
//                         scale: 1.5,
//                         child: Checkbox(
//                           value: todo.isCompleted,
//                           onChanged: (bool? newValue) {
//                             if (newValue != null) {
//                               _toggleTodoCompletion(todo, newValue, index);
//                             }
//                           },
//                           activeColor: const Color(0xFFc5a880),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../screens/todo/todo_detail_screen.dart';

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
//     setState(() {
//       _todos![index] = todo.copyWith(isCompleted: isCompleted);
//     });
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
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(8.0), // AppBar의 높이 설정
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.only(right: 20.0),
//           decoration: const BoxDecoration(
//             color: Color(0xFFe7d8bc),
//           ), // 오른쪽 패딩 추가
//           child: const Text('오늘의 할 일 목록',
//               style: TextStyle(
//                   fontSize: 20.0,
//                   fontFamily: 'Georgia',
//                   color: Color.fromARGB(136, 64, 15, 15))),
//         ),
//       ),
//       body: _todos == null
//           ? const Center(child: CircularProgressIndicator())
//           : _todos!.isEmpty
//               ? const Center(child: Text('오늘의 할 일이 없습니다.'))
//               : ListView.builder(
//                   itemCount: _todos!.length,
//                   itemBuilder: (context, index) {
//                     final todo = _todos![index];
//                     return ListTile(
//                       title: Text(
//                         todo.todoTitle,
//                         style: const TextStyle(
//                           fontFamily: 'Georgia', // 고풍스러운 글꼴
//                           fontSize: 18,
//                           color: Colors.black54, // 부드러운 텍스트 색상
//                         ),
//                       ),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return TodoDetailScreen(todoId: todo.id!);
//                           },
//                         );
//                       },
//                       trailing: Transform.scale(
//                         scale: 1.5,
//                         child: Checkbox(
//                           value: todo.isCompleted,
//                           onChanged: (bool? newValue) {
//                             if (newValue != null) {
//                               _toggleTodoCompletion(todo, newValue, index);
//                             }
//                           },
//                           activeColor: const Color(0xFFc5a880), // 고풍스러운 체크박스 색상
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../screens/todo/todo_detail_screen.dart';

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
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(8.0), // AppBar의 높이 설정
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.only(right: 20.0),
//           decoration: const BoxDecoration(
//             color: Color(0xFFe7d8bc),
//           ), // 오른쪽 패딩 추가
//           child: const Text('오늘의 할 일 목록', style: TextStyle(fontSize: 20.0)),
//         ),
//       ),
//       body: _todos == null
//           ? const Center(child: CircularProgressIndicator())
//           : _todos!.isEmpty
//               ? const Center(child: Text('오늘의 할 일이 없습니다.'))
//               : ListView.builder(
//                   itemCount: _todos!.length,
//                   itemBuilder: (context, index) {
//                     final todo = _todos![index];
//                     return ListTile(
//                       title: Text(todo.todoTitle),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return TodoDetailScreen(todoId: todo.id!);
//                           },
//                         );
//                       },
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
// 




// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../screens/todo/todo_detail_screen.dart';

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
//         title: const Text('오늘의 할 일 목록'),
//         automaticallyImplyLeading: false,
//       ),
//       body: _todos == null
//           ? const Center(child: CircularProgressIndicator())
//           : _todos!.isEmpty
//               ? const Center(child: Text('오늘의 할 일이 없습니다.'))
//               : ListView.builder(
//                   itemCount: _todos!.length,
//                   itemBuilder: (context, index) {
//                     final todo = _todos![index];
//                     return ListTile(
//                       title: Text(todo.todoTitle),
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return TodoDetailScreen(todoId: todo.id!);
//                           },
//                         );
//                       },
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
