import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/todo/todo_model.dart';
import '../../controller/todo/todo_controller.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                title:
                    Text('마감 기한: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
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
                  Navigator.of(context).pop(); // Close the modal
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('변경 사항이 저장되었습니다.')));
                },
                child: const Text('변경 사항 저장'),
              ),
            ],
          ),
        ),
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
