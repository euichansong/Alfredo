package org.b104.alfredo.todo.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.todo.request.TodoCreateDto;
import org.b104.alfredo.todo.request.TodoUpdateDto;
import org.b104.alfredo.todo.request.TodoUpdateSubDto;
import org.b104.alfredo.todo.response.TodoDetailDto;
import org.b104.alfredo.todo.response.TodoListDto;
import org.b104.alfredo.todo.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.CrossOrigin;


//@CrossOrigin(origins = "*", allowedHeaders = "*")
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

    //날짜별 조회
    @PostMapping("/bydate")
    public ResponseEntity<List<TodoListDto>> getTodosByDate(@RequestBody Map<String, String> requestBody, @RequestHeader(value = "Authorization") String authHeader) {
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            String date = requestBody.get("date");
            LocalDate parsedDate = LocalDate.parse(date); // 문자열을 LocalDate로 변환
            List<TodoListDto> todos = todoService.findAllTodosByUidAndDate(uid, parsedDate);

            return ResponseEntity.ok(todos);
        } catch (Exception e) {
            log.error("Error verifying token: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Collections.emptyList()); // 빈 목록 반환
        }
    }




    //getTodoBysubIndex 추가해야 함.
//    @PostMapping
//    public ResponseEntity<?> createTodo(@RequestHeader(value = "Authorization") String authHeader,
//                                        @RequestBody TodoCreateDto todoCreateDto) {
//        // 토큰에서 UID 추출
//        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
//        try {
//            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
//            String uid = decodedToken.getUid();
//            if (uid != null) {
//                // TodoCreateDto를 Todo 객체로 변환하고 저장
//                todoService.createTodo(todoCreateDto, uid);
//            } else {
//                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
//            }
//        } catch (Exception e) {
//            // 토큰이 유효하지 않거나 다른 오류가 발생한 경우, 예외의 상세한 원인을 로그에 포함하여 무단 상태로 반환
//            log.error("Token verification failed: {}", e.getMessage(), e);
//
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
//        }
//        return null;
//    }

    @PostMapping
    public ResponseEntity<?> createTodos(@RequestHeader(value = "Authorization") String authHeader,
                                         @RequestBody List<TodoCreateDto> todoCreateDtos) {
        // 토큰에서 UID 추출
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            if (uid != null) {
                // 각 TodoCreateDto를 순회하며 이를 Todo로 변환하고 저장
                for (TodoCreateDto todoCreateDto : todoCreateDtos) {
                    todoService.createTodo(todoCreateDto, uid);
                }

                return ResponseEntity.ok("Todos created successfully");
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
            }
        } catch (Exception e) {
            log.error("Token verification failed: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }


    @GetMapping("/{id}")
    public ResponseEntity<TodoDetailDto> getTodoById(@PathVariable Long id) {
        TodoDetailDto todoDetailDto = todoService.findTodoById(id);
        if (todoDetailDto != null) {
            return ResponseEntity.ok(todoDetailDto);
        }
        return ResponseEntity.notFound().build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<Void> updateTodo(@PathVariable Long id, @RequestBody TodoUpdateDto todoUpdateDto) {
        todoService.updateTodo(id, todoUpdateDto);
        return ResponseEntity.noContent().build();
    }

//    @PatchMapping("/sub/{subIndex}")
//    public ResponseEntity<Void> updateTodosBySubIndex(@PathVariable String subIndex, @RequestBody TodoUpdateSubDto todoUpdateSubDto) {
//        try {
//            todoService.updateTodosBySubIndex(subIndex, todoUpdateSubDto);
//            return ResponseEntity.noContent().build();
//        } catch (Exception e) {
//            log.error("An error occurred: {}", e.getMessage(), e);
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
//        }
//    }

//    @PatchMapping("/sub/{subIndex}/updateByDate")
//    public ResponseEntity<Void> updateTodosBySubIndexAndDate(
//            @PathVariable String subIndex,
//            @RequestParam String date,
//            @RequestBody TodoUpdateSubDto updateDto) {
//        try {
//            LocalDate parsedDate = LocalDate.parse(date); // 문자열을 LocalDate로 변환
//            todoService.updateTodosBySubIndexAndDate(subIndex, parsedDate, updateDto);
//            return ResponseEntity.noContent().build(); // 성공 시 No Content 응답 반환
//        } catch (Exception e) {
//            log.error("Error updating todos with subIndex and date: {}", e.getMessage(), e);
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 실패 시 오류 응답 반환
//        }
//    }
//@PatchMapping("/sub/{subIndex}/updateByDate")
//public ResponseEntity<Void> updateTodosBySubIndexAndDate(
//        @PathVariable String subIndex,
//        @RequestBody TodoUpdateSubDto updateDto) {
//    try {
//        LocalDate parsedDate = updateDto.getDate(); // `TodoUpdateSubDto`에서 `date` 가져오기
//        todoService.updateTodosBySubIndexAndDate(updateDto); // 서비스에 `updateDto` 전달
//
//        return ResponseEntity.noContent().build(); // 성공 시 No Content 응답 반환
//    } catch (Exception e) {
//        log.error("Error updating todos with subIndex and date: {}", e.getMessage(), e);
//        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 실패 시 오류 응답 반환
//    }
//}


    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
        todoService.deleteTodo(id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/updateBySubIndex")
    public ResponseEntity<Void> updateTodosBySubIndexAndDate(@RequestBody TodoUpdateSubDto updateDto) {
        try {
            todoService.updateTodosBySubIndexAndDate(updateDto); // 서비스에 `updateDto` 전달

            return ResponseEntity.noContent().build(); // 성공 시 No Content 응답 반환
        } catch (Exception e) {
            log.error("Error updating todos with subIndex and date: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); // 실패 시 오류 응답 반환
        }
    }









//    @PatchMapping("/subIndex/{subIndex}")
//    public ResponseEntity<?> updateTodos(@PathVariable Long subIndex,
//                                         @RequestHeader(value = "Authorization") String authHeader,
//                                         @RequestBody TodoCreateDto todoUpdateDto) {
//        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
//        try {
//            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
//            String uid = decodedToken.getUid();
//
//            if (uid != null) {
//                List<Todo> todos = todoService.findAllBySubIndexAndUid(subIndex, uid);
//
//                if (!todos.isEmpty()) {
//                    for (Todo todo : todos) {
//                        todo.setTodoTitle(todoUpdateDto.getTodoTitle());
//                        todo.setTodoContent(todoUpdateDto.getTodoContent());
//                        todo.setDueDate(todoUpdateDto.getDueDate());
//                        todo.setSpentTime(todoUpdateDto.getSpentTime());
//                        todo.setIsCompleted(todoUpdateDto.getIsCompleted());
//                        todo.setUrl(todoUpdateDto.getUrl());
//                        todo.setPlace(todoUpdateDto.getPlace());
//
//                        todoService.save(todo); // 업데이트된 Todo 저장
//                    }
//
//                    return ResponseEntity.ok("Todos updated successfully");
//                } else {
//                    return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Todo not found");
//                }
//            } else {
//                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
//            }
//        } catch (Exception e) {
//            log.error("Token verification failed: {}", e.getMessage(), e);
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
//        }
//    }




}
//
//    @DeleteMapping("/{id}")
//    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
//        todoService.deleteTodo(id);
//        return ResponseEntity.ok().build();
//    }
//}

