package org.b104.alfredo.todo.service;

import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.response.ScheduleDetailDto;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.todo.request.TodoCreateDto;
import org.b104.alfredo.todo.response.TodoDetailDto;
import org.b104.alfredo.todo.response.TodoListDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Service
@RequiredArgsConstructor
public class TodoService {
    private final TodoRepository todoRepository;

    @Transactional
    public List<TodoListDto> findAllTodosByUid(String uid) {
        // 데이터베이스 조회 결과 가져오기
        List<Todo> todos = todoRepository.findAllByUid(uid);
        return todos.stream()
                .map(TodoListDto::new)
                .collect(Collectors.toList());
        // 결과 검증 및 리턴
    }

//    @Builder
    @Transactional
    public void createTodo(TodoCreateDto todoCreateDto, String uid) {
        Todo todo = Todo.builder()
                .subIndex(todoCreateDto.getSubIndex())
                .todoTitle(todoCreateDto.getTodoTitle())
                .todoContent(todoCreateDto.getTodoContent())
                .dueDate(todoCreateDto.getDueDate())
                .spentTime(todoCreateDto.getSpentTime())
                .isCompleted(todoCreateDto.getIsCompleted())
                .url(todoCreateDto.getUrl())
                .place(todoCreateDto.getPlace())
                .uid(uid)
                .build();
        todoRepository.save(todo);

    }
    @Transactional
    public TodoDetailDto findTodoById(Long id) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
        return new TodoDetailDto(todo);
    }
}

//     Todo saveTodo(TodoCreateDto todoCreateDto) {
//        Todo todo = Todo.builder()
//                .subIndex(todoCreateDto.getSubIndex())
//                .todoTitle(todoCreateDto.getTodoTitle())
//                .todoContent(todoCreateDto.getTodoContent())
//                .dueDate(todoCreateDto.getDueDate())
//                .spentTime(todoCreateDto.getSpentTime())
//                .isCompleted(todoCreateDto.getIsCompleted())
//                .url(todoCreateDto.getUrl())
//                .place(todoCreateDto.getPlace())
//                .build();
//        return todoRepository.save(todo);
//    }


//    @Transactional
//    public TodoCreateDto saveTodo(TodoCreateDto todoCreateDto) {
//        return todoRepository.save(todoCreateDto);
//    }




//@Override
//@Transactional
//public void deleteTodo(Long id) {
//    todoRepository.deleteById(id);
//}
//}

