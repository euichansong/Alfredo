package org.b104.alfredo.todo.repository;

import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.request.TodoCreateDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    List<Todo> findAllByUid(String uid); // uid로 할 일 목록 조회

}