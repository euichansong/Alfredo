package org.b104.alfredo.todo.service;

import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TodoServiceImpl implements TodoService {

    private final TodoRepository todoRepository;

    @Autowired
    public TodoServiceImpl(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Todo> findAllTodos() {
        return todoRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Todo findTodoById(Long id) {
        return todoRepository.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Todo saveTodo(Todo todo) {
        return todoRepository.save(todo);
    }

    @Override
    @Transactional
    public void deleteTodo(Long id) {
        todoRepository.deleteById(id);
    }
}

