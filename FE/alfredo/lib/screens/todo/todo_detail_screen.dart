// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../api/todo/todo_api.dart';

// // TodoDetailScreen 위젯 정의, 모달 형태로 구현
// class TodoDetailScreen extends ConsumerWidget {
//   final int todoId;
//   const TodoDetailScreen({super.key, required this.todoId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Dialog(
//       child: Container(
//         width: double.maxFinite,
//         padding: const EdgeInsets.all(16),
//         child: FutureBuilder<Todo>(
//           future: ref.read(todoControllerProvider).fetchTodoById(todoId),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const SizedBox(
//                 height: 200, // Just enough height to accommodate the loader
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             } else if (snapshot.hasError) {
//               return Center(child: Text('오류: ${snapshot.error.toString()}'));
//             } else if (snapshot.hasData) {
//               return TodoDetailForm(
//                   todo: snapshot.data!,
//                   todoController: ref.read(todoControllerProvider));
//             } else {
//               return const Center(child: Text('데이터를 불러올 수 없습니다.'));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/todo/todo_model.dart';
import '../../controller/todo/todo_controller.dart';
import '../../provider/todo/todo_provider.dart';
import '../../api/todo/todo_api.dart';

// TodoDetailScreen을 StatefulWidget으로 변경
class TodoDetailScreen extends StatefulWidget {
  final int todoId;
  const TodoDetailScreen({super.key, required this.todoId});

  @override
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, _) {
            return FutureBuilder<Todo>(
              future:
                  ref.read(todoControllerProvider).fetchTodoById(widget.todoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('오류: ${snapshot.error.toString()}'));
                } else if (snapshot.hasData) {
                  return TodoDetailForm(
                      todo: snapshot.data!,
                      todoController: ref.read(todoControllerProvider));
                } else {
                  return const Center(child: Text('데이터를 불러올 수 없습니다.'));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

// TodoDetailForm 위젯 정의, 사용자 입력을 받아 Todo 정보를 표시 및 수정 가능
class TodoDetailForm extends StatefulWidget {
  final Todo todo;
  final TodoController todoController;
  const TodoDetailForm({
    super.key,
    required this.todo,
    required this.todoController,
  });

  @override
  _TodoDetailFormState createState() => _TodoDetailFormState();
}

class _TodoDetailFormState extends State<TodoDetailForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _urlController;
  late TextEditingController _placeController;
  late int _spentTime;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.todoTitle);
    _contentController = TextEditingController(text: widget.todo.todoContent);
    _urlController = TextEditingController(text: widget.todo.url);
    _placeController = TextEditingController(text: widget.todo.place);
    _spentTime = widget.todo.spentTime ?? 0;
    _dueDate = widget.todo.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: '제목'),
          ),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: '내용'),
            maxLines: 3,
          ),
          ListTile(
            title: Text('마감 기한: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _dueDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _dueDate) {
                setState(() {
                  _dueDate = picked;
                });
              }
            },
          ),
          TextFormField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: 'URL'),
          ),
          TextFormField(
            controller: _placeController,
            decoration: const InputDecoration(labelText: '장소'),
          ),
          TextFormField(
            initialValue: _spentTime.toString(),
            decoration: const InputDecoration(labelText: '소요 시간(분)'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _spentTime = int.tryParse(value) ?? _spentTime;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedTodo = Todo(
                id: widget.todo.id,
                todoTitle: _titleController.text,
                todoContent: _contentController.text,
                dueDate: _dueDate,
                url: _urlController.text,
                place: _placeController.text,
                spentTime: _spentTime,
                isCompleted: widget.todo.isCompleted,
              );
              await widget.todoController.updateTodo(updatedTodo);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('변경 사항이 저장되었습니다.'),
                duration: Duration(seconds: 2),
              ));
              Navigator.pushReplacementNamed(context, '/main'); // 수정된 부분
            },
            child: const Text('변경 사항 저장'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.todoController.deleteTodoById(widget.todo.id!);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('To-Do 항목이 삭제되었습니다.'),
                duration: Duration(seconds: 2),
              ));
              Navigator.pushReplacementNamed(context, '/main'); // 수정된 부분
            },
            child: const Text('삭제'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _urlController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import 'todo_detail_form.dart'; // TodoDetailForm import

// class TodoDetailScreen extends ConsumerWidget {
//   final int todoId;
//   const TodoDetailScreen({super.key, required this.todoId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // showModal 함수를 사용하여 모달 다이얼로그를 생성
//     void _showTodoDetailDialog() {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             child: Container(
//               padding: const EdgeInsets.all(16.0),
//               child: FutureBuilder<Todo>(
//                 future: ref.read(todoControllerProvider).fetchTodoById(todoId),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const SizedBox(width: 300, height: 400, child: Center(child: CircularProgressIndicator()));
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('오류: ${snapshot.error.toString()}'));
//                   } else if (snapshot.hasData) {
//                     return TodoDetailForm(
//                       todo: snapshot.data!,
//                       todoController: ref.read(todoControllerProvider)
//                     );
//                   } else {
//                     return const Center(child: Text('데이터를 불러올 수 없습니다.'));
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       );
//     }

//     // 버튼이나 다른 트리거를 통해 _showTodoDetailDialog 함수 호출
//     return ListTile(
//       title: Text('Todo 상세 보기'),
//       onTap: _showTodoDetailDialog, // 사용자가 리스트 항목을 탭할 때 다이얼로그를 띄웁니다.
//     );
//   }
// }
