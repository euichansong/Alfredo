import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 화면 파일들의 경로를 정확히 지정합니다.
import 'todo_create_screen.dart'; // 단일 할 일 생성 화면
import 'recurring_todo_create_screen.dart'; // 반복 할 일 생성 화면

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
