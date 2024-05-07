import '../../api/todo/todo_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/todo/todo_model.dart';
import '../../provider/user/future_provider.dart';

class TodoController {
  final TodoApi api = TodoApi();
  final ProviderRef ref;

  TodoController(this.ref);

  Future<String> createTodos(List<Todo> todos) async {
    final token = await ref.read(authManagerProvider.future);
    if (token != null) {
      return await api.createTodos(todos, token);
    } else {
      throw Exception('Authentication token not available');
    }
  }

  Future<List<Todo>> fetchTodosByDate(DateTime date) async {
    // 토큰을 제공하는 프로바이더에서 토큰 가져오기
    final token = await ref.read(authManagerProvider.future);
    if (token != null) {
      // 토큰이 있다면, API를 호출하여 특정 날짜의 To-Do 목록 가져오기
      return await api.fetchTodosByDate(date, token);
    } else {
      // 토큰이 없으면 예외 처리
      throw Exception('Authentication token not available');
    }
  }

  // Fetch a single todo by its ID
  Future<Todo> fetchTodoById(int id) async {
    final token = await ref.read(authManagerProvider.future);
    if (token != null) {
      return await api.fetchTodoById(id);
    } else {
      throw Exception('Authentication token not available');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    final token = await ref.read(authManagerProvider.future);
    if (token == null) throw Exception('Authentication token not available');
    if (todo.id != null) {
      await api.updateTodo(todo.id!, todo, token);
      // 업데이트 후 전체 리스트를 다시 불러오는 로직 추가
      await fetchTodosByDate(DateTime.now());
    } else {
      throw Exception('Todo ID is null');
    }
  }

  Future<void> deleteTodoById(int id) async {
    final token = await ref.read(authManagerProvider.future);
    if (token != null) {
      await api.deleteTodoById(id);
    } else {
      throw Exception('Authentication token not available');
    }
  }
}
