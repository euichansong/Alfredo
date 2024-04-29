package org.b104.alfredo.todo.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.todo.request.TodoCreateDto;
import org.b104.alfredo.todo.response.TodoDetailDto;
import org.b104.alfredo.todo.response.TodoListDto;
import org.b104.alfredo.todo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.CrossOrigin;


@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api/todo")
public class TodoController {
    private static final Logger log = LoggerFactory.getLogger(TodoController.class);
    private final TodoService todoService;

    @Autowired
    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }

    @GetMapping
    public ResponseEntity<?> getTodosByUser(@RequestHeader(value = "Authorization") String authHeader) {
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            List<TodoListDto> todos = todoService.findAllTodosByUid(uid);
            if (todos != null && !todos.isEmpty()) {
                return ResponseEntity.ok(todos);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("No todos found for this user");
            }
        } catch (Exception e) {
            log.error("Error verifying token: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }


    //getTodoBysubIndex 추가해야 함.
    @PostMapping
    public ResponseEntity<?> createTodo(@RequestHeader(value = "Authorization") String authHeader,
                                        @RequestBody TodoCreateDto todoCreateDto) {
        // 토큰에서 UID 추출
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            if (uid != null) {
                // TodoCreateDto를 Todo 객체로 변환하고 저장
                todoService.createTodo(todoCreateDto, uid);
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
            }
        } catch (Exception e) {
            // 토큰이 유효하지 않거나 다른 오류가 발생한 경우, 예외의 상세한 원인을 로그에 포함하여 무단 상태로 반환
            log.error("Token verification failed: {}", e.getMessage(), e);

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
        return null;
    }

    @GetMapping("/{id}")
    public ResponseEntity<TodoDetailDto> getTodoById(@PathVariable Long id) {
        TodoDetailDto todoDetailDto = todoService.findTodoById(id);
        if (todoDetailDto != null) {
            return ResponseEntity.ok(todoDetailDto);
        }
        return ResponseEntity.notFound().build();
    }



//    @PatchMapping("/{id}")
//    public ResponseEntity<Todo> updateTodoFields(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
//        Todo currentTodo = todoService.findAllById(id).orElse(null);
//        if (currentTodo == null) {
//            return ResponseEntity.notFound().build();
//        }
//
//        updates.forEach((key, value) -> {
//            switch (key) {
//                case "todoTitle":
//                    currentTodo.setTodoTitle((String) value);
//                    break;
//                case "todoContent":
//                    currentTodo.setTodoContent((String) value);
//                    break;
//                case "dueDate":
//                    currentTodo.setDueDate((LocalDate) value);
//                    break;
//                case "spentTime":
//                    currentTodo.setSpentTime((Integer) value);
//                    break;
//                case "isCompleted":
//                    currentTodo.setIsCompleted((Boolean) value);
//                    break;
//                case "url":
//                    currentTodo.setUrl((String) value);
//                    break;
//                case "place":
//                    currentTodo.setPlace((String) value);
//                    break;
//                default:
//                    // Ignore unknown fields or throw an exception
//                    break;
//            }
//        });
//        return ResponseEntity.ok(currentTodo);
//    }
}
//
//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
//        todoService.deleteTodo(id);
//        return ResponseEntity.ok().build();
//    }
//}

