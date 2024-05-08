package org.b104.alfredo.todo.service;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.todo.domain.Day;
import org.b104.alfredo.todo.domain.OldTodo;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.DayRepository;
import org.b104.alfredo.todo.repository.OldTodoRepository;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.todo.request.TodoCreateDto;
import org.b104.alfredo.todo.request.TodoUpdateDto;
import org.b104.alfredo.todo.request.TodoUpdateSubDto;
import org.b104.alfredo.todo.response.TodoDetailDto;
import org.b104.alfredo.todo.response.TodoListDto;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.TextStyle;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

@Slf4j
@Getter
@Setter
@Service
@RequiredArgsConstructor
public class TodoService {
    private final TodoRepository todoRepository;
    private final OldTodoRepository oldTodoRepository;
    private final DayRepository dayRepository;

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


//    @Transactional
//    public void updateTodo(Long id, TodoUpdateDto todoUpdateDto) {
//        Todo todo = todoRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("No Todo found for ID=" + id));
//
//        boolean previousCompleted = todo.getIsCompleted();
//
//        if (todoUpdateDto.getTodoTitle() != null) {
//            todo.setTodoTitle(todoUpdateDto.getTodoTitle());
//        }
//        if (todoUpdateDto.getTodoContent() != null) {
//            todo.setTodoContent(todoUpdateDto.getTodoContent());
//        }
//        if (todoUpdateDto.getDueDate() != null) {
//            todo.setDueDate(todoUpdateDto.getDueDate());
//        }
//        if (todoUpdateDto.getSpentTime() != null) {
//            todo.setSpentTime(todoUpdateDto.getSpentTime());
//        }
//        if (todoUpdateDto.getIsCompleted() != null) {
//            todo.setIsCompleted(todoUpdateDto.getIsCompleted());
//        }
//        if (todoUpdateDto.getUrl() != null) {
//            todo.setUrl(todoUpdateDto.getUrl());
//        }
//        if (todoUpdateDto.getPlace() != null) {
//            todo.setPlace(todoUpdateDto.getPlace());
//        }
//
//        todoRepository.save(todo);
//
//        // 변경 후 isCompleted가 바뀌었는지 확인
//        if (todoUpdateDto.getIsCompleted() != null && previousCompleted != todo.getIsCompleted()) {
//            DayOfWeek dayOfWeek = todo.getDueDate().getDayOfWeek();
//            String dayName = dayOfWeek.getDisplayName(TextStyle.FULL, Locale.ENGLISH);
//            int change = todo.getIsCompleted() ? 1 : -1;
//            updateDayTable(todo.getUid(), dayName, change);
//        }
//    }
//
//    private void updateDayTable(String uid, String day, int change) {
//        //findByUid 를 findAllbyUid로 변경함.
//        Day dayEntry = dayRepository.findAllByUid(uid);
//        if (dayEntry == null) {
//            dayEntry = new Day();
//            dayEntry.setUid(uid);
//        }
//
//        switch (day.toLowerCase()) {
//            case "sunday":
//                dayEntry.setSun(dayEntry.getSun() + change);
//                break;
//            case "monday":
//                dayEntry.setMon(dayEntry.getMon() + change);
//                break;
//
//        }
//
//        dayRepository.save(dayEntry);
//    }
    @Transactional
    public void updateTodo(Long id, TodoUpdateDto todoUpdateDto) {
        Todo todo = todoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("No Todo found for ID=" + id));

        boolean previousCompleted = todo.getIsCompleted();

        // Update fields
        updateTodoFields(todo, todoUpdateDto);

        // Save the updated todo
        todoRepository.save(todo);

        // Check if isCompleted has changed
        if (todoUpdateDto.getIsCompleted() != null && previousCompleted != todo.getIsCompleted()) {
            int dayIndex = todo.getDueDate().getDayOfWeek().getValue() % 7;  // Convert DayOfWeek to 0-indexed integer
            int change = todo.getIsCompleted() ? 1 : -1;
            updateDayTable(todo.getUid(), dayIndex, change);
        }
    }

        private void updateTodoFields(Todo todo, TodoUpdateDto todoUpdateDto) {
            if (todoUpdateDto.getTodoTitle() != null) {
                todo.setTodoTitle(todoUpdateDto.getTodoTitle());
            }
            if (todoUpdateDto.getTodoContent() != null) {
                todo.setTodoContent(todoUpdateDto.getTodoContent());
            }
            if (todoUpdateDto.getDueDate() != null) {
                todo.setDueDate(todoUpdateDto.getDueDate());
            }
            if (todoUpdateDto.getSpentTime() != null) {
                todo.setSpentTime(todoUpdateDto.getSpentTime());
            }
            if (todoUpdateDto.getIsCompleted() != null) {
                todo.setIsCompleted(todoUpdateDto.getIsCompleted());
            }
            if (todoUpdateDto.getUrl() != null) {
                todo.setUrl(todoUpdateDto.getUrl());
            }
            if (todoUpdateDto.getPlace() != null) {
                todo.setPlace(todoUpdateDto.getPlace());
            }
        }

    private void updateDayTable(String uid, int dayIndex, int change) {
        Optional<Day> dayOpt = dayRepository.findByUidAndDayIndex(uid, dayIndex);
        Day dayEntry = dayOpt.orElseGet(() -> {
            Day newDayEntry = new Day();
            newDayEntry.setUid(uid);
            newDayEntry.setDayIndex(dayIndex);
            newDayEntry.setCount(0); // 새로운 Day 엔티티의 카운트를 0으로 설정합니다.
            return newDayEntry;
        });

        // Update the count for the specific day
        int updatedCount = dayEntry.getCount() + change;
        dayEntry.setCount(updatedCount);

        // Save the updated day entry
        dayRepository.save(dayEntry);
    }




    @Transactional
    public List<TodoListDto> findAllTodosByUidAndDate(String uid, LocalDate date) {
        List<Todo> todos = todoRepository.findAllByUidAndDueDate(uid, date);

        return todos.stream()
                .map(TodoListDto::new)
                .collect(Collectors.toList());
    }




//    @Transactional
//    public void updateTodosBySubIndex(String subIndex, TodoUpdateSubDto todoUpdateSubDto) {
//        List<Todo> todos = todoRepository.findBySubIndex(subIndex);
//
//        if (todos.isEmpty()) {
//            throw new RuntimeException("No Todos found with subIndex: " + subIndex);
//        }
//
//        for (Todo todo : todos) {
//            if (todoUpdateSubDto.getTodoTitle() != null) {
//                todoUpdateSubDto.getTodoTitle().ifPresent(todo::setTodoTitle);
//            }
//            if (todoUpdateSubDto.getTodoContent() != null) {
//                todoUpdateSubDto.getTodoContent().ifPresent(todo::setTodoContent);
//            }
//            if (todoUpdateSubDto.getDueDate() != null) {
//                todoUpdateSubDto.getDueDate().ifPresent(todo::setDueDate);
//            }
//            if (todoUpdateSubDto.getSpentTime() != null) {
//                todoUpdateSubDto.getSpentTime().ifPresent(todo::setSpentTime);
//            }
//            if (todoUpdateSubDto.getIsCompleted() != null) {
//                todoUpdateSubDto.getIsCompleted().ifPresent(todo::setIsCompleted);
//            }
//            if (todoUpdateSubDto.getUrl() != null) {
//                todoUpdateSubDto.getUrl().ifPresent(todo::setUrl);
//            }
//            if (todoUpdateSubDto.getPlace() != null) {
//                todoUpdateSubDto.getPlace().ifPresent(todo::setPlace);
//            }
//
//            todoRepository.save(todo);
//        }
//    }
    @Transactional
    public void deleteTodo(Long id) {
        todoRepository.deleteById(id);
    }

    @Transactional
    public void deleteTodosBySubIndexAndDueDate(String subIndex, LocalDate dueDate) {
        List<Todo> todosToDelete = todoRepository.findBySubIndexAndDueDateAfterOrEqual(subIndex, dueDate);
        if (!todosToDelete.isEmpty()) {
            todoRepository.deleteAll(todosToDelete);
            log.info("Deleted {} todos with subIndex '{}' and dueDate '{}'", todosToDelete.size(), subIndex, dueDate);
        } else {
            log.warn("No todos found with subIndex '{}' and dueDate '{}'", subIndex, dueDate);
        }
    }



//    @Transactional
//    public void updateTodosBySubIndexAndDate(TodoUpdateSubDto updateDto) {
//        String subIndex = updateDto.getSubIndex(); // `subIndex` 값을 가져옵니다.
//        LocalDate date = updateDto.getDate(); // `date` 값을 가져옵니다.
//
//        List<Todo> todos = todoRepository.findBySubIndexAndDueDateAfterOrEqual(subIndex, date); // `subIndex`와 `date` 이후의 항목들 가져오기
//
//        if (todos.isEmpty()) {
//            log.warn("No Todos found with subIndex '{}' and date after '{}'", subIndex, date);
//            return;
//        }
//
//        log.info("Found {} Todos with subIndex '{}' and date after '{}'", todos.size(), subIndex, date);
//
//        for (Todo todo : todos) {
//            if (updateDto.getTodoTitle() != null) {
//                todo.setTodoTitle(updateDto.getTodoTitle());
//            }
//            // 다른 필드들도 동일하게 검사하고 업데이트합니다.
//
//            todoRepository.save(todo); // 업데이트 후 저장
//            log.info("Updated Todo with ID {}", todo.getId());
//        }
//    }
    @Transactional
    public void updateTodosBySubIndexAndDate(TodoUpdateSubDto updateDto) {
        String subIndex = updateDto.getSubIndex(); // `subIndex` 값을 가져옵니다.
        LocalDate date = updateDto.getDueDate(); // `date` 값을 가져옵니다.

        List<Todo> todos = todoRepository.findBySubIndexAndDueDateAfterOrEqual(subIndex, date); // `subIndex`와 `date` 이후의 항목들을 가져옵니다.

        if (todos.isEmpty()) {
            log.warn("No Todos found with subIndex '{}' and date after '{}'", subIndex, date);
            return;
        }

        log.info("Found {} Todos with subIndex '{}' and date after '{}'", todos.size(), subIndex, date);

        for (Todo todo : todos) {
            if (updateDto.getTodoTitle() != null) {
                todo.setTodoTitle(updateDto.getTodoTitle());
                todo.setTodoContent(updateDto.getTodoContent());
                todo.setUrl(updateDto.getUrl());
                todo.setPlace(updateDto.getPlace());
            }
            // 필요한 경우 추가적인 필드를 검사하고 업데이트합니다.

            todoRepository.save(todo); // 업데이트 후 저장
            log.info("Updated Todo with ID {}", todo.getId());
        }
    }

    // Todo의 ID를 사용하여 해당 Todo를 찾는 메서드
    public Todo findById(Long id) {
        // TodoRepository의 findById 메서드를 사용하여 Todo를 찾습니다.
        // findById 메서드는 Optional<Todo>를 반환하므로, Optional의 get() 메서드를 사용하여 Todo를 가져옵니다.
        return todoRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("No Todo found for ID=" + id));
    }









}







//    @Transactional
//    public void updateTodoById(TodoUpdateDto todoUpdateDto, Long id) {
//        Todo todo = todoRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
//        return new TodoUpdateDto(todo);
//    }

//    @Transactional
//    public TodoUpdateDto updateTodoById(Long id, TodoUpdateDto todoUpdateDto) {
//        Todo todo = todoRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
//        todo.update(todoUpdateDto.getSubIndex(),
//                todoUpdateDto.getTodoTitle(),
//                todoUpdateDto.getTodoContent(),
//                todoUpdateDto.getDueDate(),
//                todoUpdateDto.getSpentTime(),
//                todoUpdateDto.getIsCompleted(),
//                todoUpdateDto.getUrl(),
//                todoUpdateDto.getPlace());
//        return todoUpdateDto;
//    }


//    @Transactional
//    public void deleteTodoById(Long id) {
//        Todo todo = todoRepository.findById(id)
//                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
//        todoRepository.delete(todo);
//    }
//





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

