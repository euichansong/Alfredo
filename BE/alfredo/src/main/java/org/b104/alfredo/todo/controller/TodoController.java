package org.b104.alfredo.todo.controller;

import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.CrossOrigin;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api/todo")
public class TodoController {

    private final TodoService todoService;

    @Autowired
    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    @GetMapping
    public ResponseEntity<List<Todo>> getAllTodos() {
        return ResponseEntity.ok(todoService.findAllTodos());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Todo> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.findTodoById(id);
        if (todo != null) {
            return ResponseEntity.ok(todo);
        }
        return ResponseEntity.notFound().build();
    }
    //getTodoBysubIndex 추가해야 함.
    @PostMapping("/create")
    public ResponseEntity<Todo> createTodo(@RequestBody Todo todo) {
        Todo savedTodo = todoService.saveTodo(todo);
        return ResponseEntity.ok(savedTodo);
    }

//    @PutMapping("/{id}")
//    public ResponseEntity<Todo> updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
//        Todo currentTodo = todoService.findTodoById(id);
//        if (currentTodo != null) {
//            currentTodo.setTodoTitle(todo.getTodoTitle());
//            currentTodo.setTodoContent(todo.getTodoContent());
//            currentTodo.setDueDate(todo.getDueDate());
//            currentTodo.setSpentTime(todo.getSpentTime());
//            currentTodo.setIsCompleted(todo.getIsCompleted());
//            currentTodo.setUrl(todo.getUrl());
//            currentTodo.setPlace(todo.getPlace());
//            todoService.saveTodo(currentTodo);
//            return ResponseEntity.ok(currentTodo);
//        }
//        return ResponseEntity.notFound().build();
//    }

    @PatchMapping("/{id}")
    public ResponseEntity<Todo> updateTodoFields(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
        Todo currentTodo = todoService.findTodoById(id);
        if (currentTodo == null) {
            return ResponseEntity.notFound().build();
        }

        updates.forEach((key, value) -> {
            switch (key) {
                case "todoTitle":
                    currentTodo.setTodoTitle((String) value);
                    break;
                case "todoContent":
                    currentTodo.setTodoContent((String) value);
                    break;
                case "dueDate":
                    currentTodo.setDueDate((LocalDate) value);
                    break;
                case "spentTime":
                    currentTodo.setSpentTime((Integer) value);
                    break;
                case "isCompleted":
                    currentTodo.setIsCompleted((Boolean) value);
                    break;
                case "url":
                    currentTodo.setUrl((String) value);
                    break;
                case "place":
                    currentTodo.setPlace((String) value);
                    break;
                default:
                    // Ignore unknown fields or throw an exception
                    break;
            }
        });

        todoService.saveTodo(currentTodo);
        return ResponseEntity.ok(currentTodo);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
        return ResponseEntity.ok().build();
    }
}

