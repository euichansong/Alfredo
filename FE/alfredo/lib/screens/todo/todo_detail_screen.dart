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
          // ElevatedButton(
          //   onPressed: () async {
          //     final updatedTodo = Todo(
          //       id: widget.todo.id,
          //       todoTitle: _titleController.text,
          //       todoContent: _contentController.text,
          //       dueDate: _dueDate,
          //       url: _urlController.text,
          //       place: _placeController.text,
          //       spentTime: _spentTime,
          //       isCompleted: widget.todo.isCompleted,
          //     );
          //     await widget.todoController.updateTodo(updatedTodo);
          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //       content: Text('변경 사항이 저장되었습니다.'),
          //       duration: Duration(seconds: 2),
          //     ));
          //     Navigator.pushReplacementNamed(context, '/main'); // 수정된 부분
          //   },
          //   child: const Text('변경 사항 저장'),
          // ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Todo 업데이트'),
                    content: const Text('원하는 업데이트 방식을 선택하세요.'),
                    actions: <Widget>[
                      TextButton(
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
                          Navigator.of(context).pop(); // Close the modal
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('변경 사항이 저장되었습니다.')));
                        },
                        child: const Text('기본 업데이트'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Todo 객체를 생성하고 모든 필요한 데이터를 포함
                          final updatedSubTodo = Todo(
                              subIndex: widget.todo.subIndex, // subIndex
                              todoTitle: _titleController.text, // 제목
                              todoContent: _contentController.text, // 내용
                              dueDate: _dueDate, // 날짜
                              url: _urlController.text, // URL
                              place: _placeController.text, // 장소
                              spentTime: _spentTime, // 소요 시간
                              isCompleted: widget.todo.isCompleted // 완료 상태
                              );

                          // Todo 객체와 함께 메서드 호출
                          await widget.todoController
                              .updateTodosBySubIndexAndDate(updatedSubTodo);
                          Navigator.of(context).pop(); // 모달 닫기
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('SubIndex 업데이트 완료.')));
                        },
                        child: const Text('SubIndex 업데이트'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Todo 업데이트'),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('삭제 확인'),
                      content: const Text('삭제 방식을 선택하세요.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // 기존의 단일 항목 삭제 로직 실행
                            await widget.todoController
                                .deleteTodoById(widget.todo.id!);
                            Navigator.of(context).pop(); // 모달 닫기
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('To-Do 항목이 삭제되었습니다.')));
                            Navigator.pushReplacementNamed(context, '/main');
                          },
                          child: const Text('일반 삭제'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // SubIndex와 DueDate를 기준으로 한 삭제 로직 실행
                            await widget.todoController
                                .deleteTodoBySubIndexAndDate(
                                    widget.todo.subIndex!, widget.todo.dueDate);
                            Navigator.of(context).pop(); // 모달 닫기
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('SubIndex 기준으로 삭제 완료.')));
                            Navigator.pushReplacementNamed(context, '/main');
                          },
                          child: const Text('SubIndex 삭제'),
                        ),
                      ],
                    );
                  });
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
// import 'package:intl/intl.dart';
// import '../../models/todo/todo_model.dart';
// import '../../controller/todo/todo_controller.dart';
// import '../../provider/todo/todo_provider.dart';
// import '../../api/todo/todo_api.dart';

// class TodoDetailScreen extends ConsumerStatefulWidget {
//   final int todoId;
//   const TodoDetailScreen({super.key, required this.todoId});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _TodoDetailScreenState();
// }

// class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Todo 정보를 로드합니다.
//     ref.read(todoControllerProvider.notifier).fetchTodoById(widget.todoId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Todo> todos = ref.watch(todoControllerProvider);
//     // Todo를 찾거나, 찾지 못하면 기본 Todo 객체를 생성합니다.
//     Todo todo = todos.firstWhere(
//       (t) => t.id == widget.todoId,
//       orElse: () => Todo(
//           id: widget.todoId,
//           todoTitle: '',
//           todoContent: '',
//           url: '',
//           place: '',
//           spentTime: 0,
//           dueDate: DateTime.now(),
//           isCompleted: false),
//     );

//     return Dialog(
//       child: Container(
//         width: double.maxFinite,
//         padding: const EdgeInsets.all(16),
//         child: TodoDetailForm(
//             todo: todo,
//             todoController: ref.read(todoControllerProvider.notifier)),
//       ),
//     );
//   }
// }

// class TodoDetailForm extends StatefulWidget {
//   final Todo todo;
//   final TodoController todoController;
//   const TodoDetailForm(
//       {super.key, required this.todo, required this.todoController});

//   @override
//   _TodoDetailFormState createState() => _TodoDetailFormState();
// }

// class _TodoDetailFormState extends State<TodoDetailForm> {
//   late TextEditingController _titleController;
//   late TextEditingController _contentController;
//   late TextEditingController _urlController;
//   late TextEditingController _placeController;
//   late int _spentTime;
//   late DateTime _dueDate;

//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.todo.todoTitle);
//     _contentController = TextEditingController(text: widget.todo.todoContent);
//     _urlController = TextEditingController(text: widget.todo.url);
//     _placeController = TextEditingController(text: widget.todo.place);
//     _spentTime = widget.todo.spentTime ?? 0;
//     _dueDate = widget.todo.dueDate;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       child: ListView(
//         children: <Widget>[
//           TextFormField(
//             controller: _titleController,
//             decoration: const InputDecoration(labelText: '제목'),
//           ),
//           TextFormField(
//             controller: _contentController,
//             decoration: const InputDecoration(labelText: '내용'),
//             maxLines: 3,
//           ),
//           ListTile(
//             title: Text('마감 기한: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
//             onTap: () async {
//               final DateTime? picked = await showDatePicker(
//                 context: context,
//                 initialDate: _dueDate,
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2100),
//               );
//               if (picked != null && picked != _dueDate) {
//                 setState(() {
//                   _dueDate = picked;
//                 });
//               }
//             },
//           ),
//           TextFormField(
//             controller: _urlController,
//             decoration: const InputDecoration(labelText: 'URL'),
//           ),
//           TextFormField(
//             controller: _placeController,
//             decoration: const InputDecoration(labelText: '장소'),
//           ),
//           TextFormField(
//             initialValue: _spentTime.toString(),
//             decoration: const InputDecoration(labelText: '소요 시간(분)'),
//             keyboardType: TextInputType.number,
//             onChanged: (value) {
//               _spentTime = int.tryParse(value) ?? _spentTime;
//             },
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final updatedTodo = Todo(
//                 id: widget.todo.id,
//                 todoTitle: _titleController.text,
//                 todoContent: _contentController.text,
//                 dueDate: _dueDate,
//                 url: _urlController.text,
//                 place: _placeController.text,
//                 spentTime: _spentTime,
//                 isCompleted: widget.todo.isCompleted,
//               );
//               await widget.todoController.updateTodo(updatedTodo);
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('변경 사항이 저장되었습니다.')));
//             },
//             child: const Text('변경 사항 저장'),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     _urlController.dispose();
//     _placeController.dispose();
//     super.dispose();
//   }
// }
