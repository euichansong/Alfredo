package org.b104.alfredo.routine.repository;

import org.b104.alfredo.routine.domain.Routine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface RoutineRepository extends JpaRepository<Routine,Long> {
}
