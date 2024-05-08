package org.b104.alfredo.todo.service;

import org.b104.alfredo.todo.domain.Day;
import org.b104.alfredo.todo.repository.DayRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

// DayService.java
@Service
public class DayService {
    private final DayRepository dayRepository;

    public DayService(DayRepository dayRepository) {
        this.dayRepository = dayRepository;
    }

    public Optional<Day> findByUidAndDayIndex(String uid, int dayIndex) {
        return dayRepository.findByUidAndDayIndex(uid, dayIndex);
    }
}

