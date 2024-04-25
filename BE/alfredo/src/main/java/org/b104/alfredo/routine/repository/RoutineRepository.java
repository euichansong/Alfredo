package org.b104.alfredo.routine.repository;

import org.b104.alfredo.routine.domain.Routine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

public interface RoutineRepository extends JpaRepository<Routine,Long> {
    List<Routine> findByUserIdOrderByStartTimeAsc(Long userId);
}