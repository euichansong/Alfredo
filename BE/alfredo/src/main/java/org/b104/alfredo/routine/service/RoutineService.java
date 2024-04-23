package org.b104.alfredo.routine.service;

import org.b104.alfredo.routine.domain.Routine;

import java.util.List;

public interface RoutineService {

    List<Routine> getAllRoutines();
    Routine getRoutine(Long id);


}
