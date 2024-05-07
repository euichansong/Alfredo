import 'package:alfredo/controller/todo/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/todo/todo_model.dart';
import '../../provider/todo/todo_provider.dart';

class TodoCreateScreen extends ConsumerWidget {
  const TodoCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(todoControllerProvider);
    return _TodoCreateScreenBody(controller: controller);
  }
}

class _TodoCreateScreenBody extends StatefulWidget {
  final TodoController controller;

  const _TodoCreateScreenBody({super.key, required this.controller});

  @override
  _TodoCreateScreenState createState() => _TodoCreateScreenState();
}

class _TodoCreateScreenState extends State<_TodoCreateScreenBody> {
  final _formKey = GlobalKey<FormState>();
  String todoTitle = '';
  String? todoContent = '';
  DateTime dueDate = DateTime.now();
  String? url = '';
  String? place = '';

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dueDate) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  void _submitTodo() {
    if (_validateForm()) {
      _formKey.currentState!.save();
      final newTodo = Todo(
        todoTitle: todoTitle,
        todoContent: todoContent,
        dueDate: dueDate,
        url: url,
        place: place,
      );
      widget.controller.createTodos([newTodo]).then((resultMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(resultMessage))); // 서버로부터 받은 메시지를 직접 출력
        Navigator.pushReplacementNamed(context, '/main');
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('할 일 생성에 실패했습니다: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("할 일 생성")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: '제목'),
              onSaved: (value) => todoTitle = value ?? '',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '제목을 입력해주세요';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '내용'),
              onSaved: (value) => todoContent = value,
              maxLines: 3,
            ),
            ListTile(
              title: Text('마감 기한: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
              onTap: () => _selectDueDate(context),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'URL'),
              onSaved: (value) => url = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '장소'),
              onSaved: (value) => place = value,
            ),
            ElevatedButton(
              onPressed: _submitTodo,
              child: const Text('할 일 추가'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    return _formKey.currentState!.validate();
  }
}




// import 'package:alfredo/controller/todo/todo_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가
// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';

// class TodoCreateScreen extends ConsumerWidget {
//   const TodoCreateScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.read(todoControllerProvider);
//     return _TodoCreateScreenBody(controller: controller);
//   }
// }

// class _TodoCreateScreenBody extends StatefulWidget {
//   final TodoController controller;

//   const _TodoCreateScreenBody({super.key, required this.controller});

//   @override
//   _TodoCreateScreenState createState() => _TodoCreateScreenState();
// }

// class _TodoCreateScreenState extends State<_TodoCreateScreenBody> {
//   final _formKey = GlobalKey<FormState>();

//   List<Todo> todos = [];
//   String todoTitle = '';
//   String? todoContent = '';
//   DateTime dueDate = DateTime.now();
//   String? url = '';
//   String? place = '';

//   Future<void> _selectDueDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: dueDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != dueDate) {
//       setState(() {
//         dueDate = picked;
//       });
//     }
//   }

//   void _addTodo() {
//     final newTodo = Todo(
//       todoTitle: todoTitle,
//       todoContent: todoContent,
//       dueDate: dueDate,
//       url: url,
//       place: place,
//     );
//     setState(() {
//       todos.add(newTodo);
//       todoTitle = '';
//       todoContent = '';
//       url = '';
//       place = '';
//       dueDate = DateTime.now();
//       _formKey.currentState!.reset();
//     });
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('할 일이 리스트에 추가되었습니다.')));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("할 일 생성")),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: <Widget>[
//             TextFormField(
//               decoration: const InputDecoration(labelText: '제목'),
//               onSaved: (value) => todoTitle = value ?? '',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return '제목을 입력해주세요';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: '내용'),
//               onSaved: (value) => todoContent = value,
//               maxLines: 3,
//             ),
//             ListTile(
//               title: Text('마감 기한: ${DateFormat('yyyy-MM-dd').format(dueDate)}'),
//               onTap: () => _selectDueDate(context),
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: 'URL'),
//               onSaved: (value) => url = value,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: '장소'),
//               onSaved: (value) => place = value,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_validateForm()) {
//                   _formKey.currentState!.save();
//                   _addTodo();
//                 }
//               },
//               child: const Text('할 일 추가'),
//             ),
//             ElevatedButton(
//               onPressed: todos.isNotEmpty
//                   ? () {
//                       widget.controller.createTodos(todos).then((value) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text('할 일들이 성공적으로 생성되었습니다.')));
//                         Navigator.pop(context);
//                       }).catchError((error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('할 일 생성에 실패했습니다: $error')));
//                       });
//                     }
//                   : null,
//               child: const Text('모든 할 일 저장'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _validateForm() {
//     return _formKey.currentState!.validate();
//   }
// }


//     // 각 필드를 위한 TextEditingController 생성
//     final titleController = TextEditingController();
//     final contentController = TextEditingController();
//     final dueDateController = TextEditingController();
//     final spentTimeController = TextEditingController();
//     final urlController = TextEditingController();
//     final placeController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Todo'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: contentController,
//               decoration: const InputDecoration(labelText: 'Content'),
//             ),
//             TextField(
//               controller: dueDateController,
//               decoration:
//                   const InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
//               keyboardType: TextInputType.datetime,
//             ),
//             TextField(
//               controller: spentTimeController,
//               decoration:
//                   const InputDecoration(labelText: 'Spent Time (minutes)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: urlController,
//               decoration: const InputDecoration(labelText: 'URL'),
//             ),
//             TextField(
//               controller: placeController,
//               decoration: const InputDecoration(labelText: 'Place'),
//             ),
//             SwitchListTile(
//               title: const Text('Is Completed'),
//               value: false,
//               onChanged: (bool newValue) {
//                 // Handle switch change
//               },
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 final newTodo = Todo(
//                   todoTitle: titleController.text,
//                   todoContent: contentController.text,
//                   dueDate: dueDateController.text,
//                   url: urlController.text,
//                   place: placeController.text,
//                 );
//                 await todoController.addTodo('your_token_here', newTodo);
//                 Navigator.pop(context);
//               },
//               child: const Text('Add Todo'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
