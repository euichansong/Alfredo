import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_create_screen.dart';
import 'recurring_todo_create_screen.dart';

class TodoTabView extends ConsumerWidget {
  const TodoTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('할 일 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: '단일 할 일'),
              Tab(icon: Icon(Icons.repeat), text: '반복 할 일'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TodoCreateScreen(),
            RecurringTodoCreateScreen(),
          ],
        ),
      ),
    );
  }
}

void showTodoModalDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const Dialog(
        child: SizedBox(
          width: 600, // 다이얼로그의 크기를 조정
          child: TodoTabView(),
        ),
      );
    },
  );
}
