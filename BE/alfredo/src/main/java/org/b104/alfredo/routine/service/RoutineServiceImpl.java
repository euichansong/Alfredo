package org.b104.alfredo.routine.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.user.User;
import org.b104.alfredo.user.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class RoutineServiceImpl implements RoutineService {
    private final RoutineRepository routineRepository;
    private final UserRepository userRepository;

    @Override
    public List<Routine> getAllRoutines(Long userId) {
        return routineRepository.findByUserIdOrderByStartTimeAsc(userId);
    }

    @Override
    public Routine getRoutine(Long id) {
        Optional<Routine> routine= routineRepository.findById(id);
        return routine.orElse(null);
    }

    //TODO dto사용구조가 아님(리팩토링 하기)
    @Override
    public Routine createRoutine(String routineTitle, LocalTime startTime, Set<String> days, String alarmSound, String memo, Long userId) {
        User user = userRepository.findById(userId).orElseThrow(() -> new RuntimeException("User not found"));
        Routine routine = new Routine();
        routine.setUser(user);
        routine.setRoutineTitle(routineTitle);
        routine.setStartTime(startTime);
        routine.setDays(days);
        routine.setAlarmSound(alarmSound);
        routine.setMemo(memo);
        return routineRepository.save(routine);
    }

    @Override
    public void deleteRoutine(Long routineId) {
        routineRepository.deleteById(routineId);
    }

    @Override
    public Routine updateRoutine(Long routineId,String routineTitle, LocalTime startTime, Set<String> days, String alarmSound, String memo) {
        Routine routine = routineRepository.findById(routineId)
                .orElseThrow(() -> new RuntimeException("Routine not found with id: " + routineId));
        routine.setRoutineTitle(routineTitle);
        routine.setStartTime(startTime);
        routine.setDays(days);
        routine.setAlarmSound(alarmSound);
        routine.setMemo(memo);
        return routineRepository.save(routine);
    }
}
