package org.b104.alfredo.achieve.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.repository.AchieveRepository;
import org.b104.alfredo.achieve.request.AchieveUpdateDto;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AchieveService {
    private final AchieveRepository achieveRepository;
    private final UserRepository userRepository;
    private final TodoRepository todoRepository;
    private final RoutineRepository routineRepository;
    private final ScheduleRepository scheduleRepository;

    // 유저로 업적 찾기
    @Transactional
    public AchieveDetailDto getAchieveDetailByUser(User user) {
        Achieve achieve = achieveRepository.findByUserId(user);
        if (achieve == null) {
            throw new IllegalArgumentException("Achieve not found for the user");
        }
        return new AchieveDetailDto(achieve);
    }

    // 6번째 업적
    @Transactional
    public void checkTotalSchedule(User user){
        // 해당 유저의 일정 개수 조회
        long count = scheduleRepository.countByUser(user);

        // 업적 상태 확인 및 업데이트
        Achieve achieve = achieveRepository.findByUserId(user);
        if (count >= 20) {
            if (!achieve.getAchieveSix()) {  // 여기서 AchieveSix는 '총 일정의 개수' 업적을 나타냅니다.
                achieve.updateAchieveSix(true);
            }
        }
    }
    // 2번째 업적
    // 3번째 업적
    // 4번째 업적
    // 5번째 업적
}
