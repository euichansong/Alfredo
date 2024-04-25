package org.b104.alfredo.todo.service;

import org.b104.alfredo.todo.domain.Todo;
import java.util.List;

public interface TodoService {
    List<Todo> findAllTodos();
    Todo findTodoById(Long id);
    Todo saveTodo(Todo todo);
    void deleteTodo(Long id);
}