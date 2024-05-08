// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart'; // UUID 패키지 임포트
// import '../../models/todo/todo_model.dart';
// import '../../provider/todo/todo_provider.dart';

// class RecurringTodoCreateScreen extends ConsumerStatefulWidget {
//   const RecurringTodoCreateScreen({super.key});

//   @override
//   _RecurringTodoCreateScreenState createState() =>
//       _RecurringTodoCreateScreenState();
// }

// class _RecurringTodoCreateScreenState
//     extends ConsumerState<RecurringTodoCreateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   DateTime startDate = DateTime.now();
//   DateTime endDate = DateTime.now().add(const Duration(days: 30));
//   List<bool> daysOfWeek = List.filled(7, false);
//   String todoTitle = '';
//   String? todoContent = '';

//   // UUID 생성 객체
//   final Uuid uuid = const Uuid();

//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? startDate : endDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           startDate = picked;
//         } else {
//           endDate = picked;
//         }
//       });
//     }
//   }

//   void _submitRecurringTodo() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       List<Todo> todosToCreate = [];
//       DateTime currentDate = startDate;

//       // UUID로 고유한 subIndex 생성
//       final String subIndex = uuid.v4();

//       while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
//         if (daysOfWeek[currentDate.weekday - 1]) {
//           // 요일 선택에 맞는 날짜에만 할 일 생성
//           final newTodo = Todo(
//             todoTitle: todoTitle,
//             todoContent: todoContent,
//             dueDate: currentDate,
//             subIndex: subIndex, // 공통된 subIndex 설정
//             url: '', // 필요하다면 URL 추가
//             place: '', // 필요하다면 장소 추가
//           );
//           todosToCreate.add(newTodo);
//         }
//         currentDate = currentDate.add(const Duration(days: 1));
//       }

//       // 할 일 목록을 데이터베이스 또는 서버에 전송
//       final controller = ref.read(todoControllerProvider.notifier);
//       controller.createTodos(todosToCreate).then((_) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text('할 일이 성공적으로 생성되었습니다.')));
//         Navigator.pop(context);
//       }).catchError((error) {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('할 일 생성에 실패했습니다: $error')));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("반복 할 일 생성")),
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: <Widget>[
//             TextFormField(
//               decoration: const InputDecoration(labelText: '제목'),
//               onSaved: (value) => todoTitle = value ?? '',
//               validator: (value) =>
//                   value == null || value.isEmpty ? '제목을 입력해주세요' : null,
//             ),
//             TextFormField(
//               decoration: const InputDecoration(labelText: '내용'),
//               onSaved: (value) => todoContent = value,
//               maxLines: 3,
//             ),
//             ListTile(
//               title:
//                   Text('시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
//               onTap: () => _selectDate(context, true),
//             ),
//             ListTile(
//               title: Text('종료 날짜: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
//               onTap: () => _selectDate(context, false),
//             ),
//             ToggleButtons(
//               isSelected: daysOfWeek,
//               onPressed: (int index) {
//                 setState(() {
//                   daysOfWeek[index] = !daysOfWeek[index];
//                 });
//               },
//               children: const <Widget>[
//                 Text('월'),
//                 Text('화'),
//                 Text('수'),
//                 Text('목'),
//                 Text('금'),
//                 Text('토'),
//                 Text('일')
//               ],
//             ),
//             ElevatedButton(
//               onPressed: _submitRecurringTodo,
//               child: const Text('할 일 추가'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart'; // UUID 패키지 임포트
import '../../models/todo/todo_model.dart';
import '../../provider/todo/todo_provider.dart';

class RecurringTodoCreateScreen extends ConsumerStatefulWidget {
  const RecurringTodoCreateScreen({super.key});

  @override
  _RecurringTodoCreateScreenState createState() =>
      _RecurringTodoCreateScreenState();
}

class _RecurringTodoCreateScreenState
    extends ConsumerState<RecurringTodoCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  List<bool> daysOfWeek = List.filled(7, false);
  String todoTitle = '';
  String? todoContent = '';

  // UUID 생성 객체
  final Uuid uuid = const Uuid();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _submitRecurringTodo() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      List<Todo> todosToCreate = [];
      DateTime currentDate = startDate;

      // UUID로 고유한 subIndex 생성
      final String subIndex = uuid.v4();

      while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
        if (daysOfWeek[currentDate.weekday - 1]) {
          // 요일 선택에 맞는 날짜에만 할 일 생성
          final newTodo = Todo(
            todoTitle: todoTitle,
            todoContent: todoContent,
            dueDate: currentDate,
            subIndex: subIndex, // 공통된 subIndex 설정
            url: '', // 필요하다면 URL 추가
            place: '', // 필요하다면 장소 추가
          );
          todosToCreate.add(newTodo);
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }

      // 할 일 목록을 데이터베이스 또는 서버에 전송
      final controller = ref.read(todoControllerProvider);
      controller.createTodos(todosToCreate).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('할 일이 성공적으로 생성되었습니다.')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('할 일 생성에 실패했습니다: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("반복 할 일 생성")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: '제목'),
              onSaved: (value) => todoTitle = value ?? '',
              validator: (value) =>
                  value == null || value.isEmpty ? '제목을 입력해주세요' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: '내용'),
              onSaved: (value) => todoContent = value,
              maxLines: 3,
            ),
            ListTile(
              title:
                  Text('시작 날짜: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              title: Text('종료 날짜: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
              onTap: () => _selectDate(context, false),
            ),
            ToggleButtons(
              isSelected: daysOfWeek,
              onPressed: (int index) {
                setState(() {
                  daysOfWeek[index] = !daysOfWeek[index];
                });
              },
              children: const <Widget>[
                Text('월'),
                Text('화'),
                Text('수'),
                Text('목'),
                Text('금'),
                Text('토'),
                Text('일')
              ],
            ),
            ElevatedButton(
              onPressed: _submitRecurringTodo,
              child: const Text('할 일 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
