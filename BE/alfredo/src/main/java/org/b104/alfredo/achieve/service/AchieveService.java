package org.b104.alfredo.achieve.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.repository.AchieveRepository;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.coin.domain.Coin;
import org.b104.alfredo.coin.repository.CoinRepository;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AchieveService {
    private final AchieveRepository achieveRepository;
    private final UserRepository userRepository;
    private final TodoRepository todoRepository;
    private final RoutineRepository routineRepository;
    private final ScheduleRepository scheduleRepository;
    private final CoinRepository coinRepository;

    // 생성
    @Transactional
    public Achieve createAchieve(User user) {
        Achieve newAchieve = Achieve.builder()
                .user(user)
                .achieveOne(false)
                .achieveTwo(false)
                .achieveThree(false)
                .achieveFour(false)
                .achieveFive(false)
                .achieveSix(false)
                .achieveSeven(false)
                .achieveEight(false)
                .achieveNine(false)
                .build();

        return achieveRepository.save(newAchieve);
    }

    // 유저로 업적 찾기
    @Transactional
    public AchieveDetailDto getAchieveDetail(User user) {
        Achieve achieve = achieveRepository.findByUser(user);  // 메소드 사용 변경
        if (achieve == null) {
            return null;
        }
        return new AchieveDetailDto(achieve);
    }

    // 6번째 업적 체크 로직 -  - 총 일정의 갯수
    @Transactional
    public void checkTotalSchedule(User user) {
        // 해당 유저의 일정 리스트 가져오기
        List<Schedule> schedules = scheduleRepository.findByUserId(user);

        // 일정의 개수 확인
        int count = schedules.size();
//        System.out.println(count);
        // 업적 상태 확인 및 업데이트
        Achieve achieve = achieveRepository.findByUser(user);
        if (count >= 2 && (achieve != null && !achieve.getAchieveSix())) {
            achieve.updateAchieveSix(true);

            // 6번째 업적이 달성되었으므로 Coin 업데이트
            Coin coin = coinRepository.findByUserId(user);
            if (coin != null) {
                coin.updateTotalCoin(coin.getTotalCoin() + 10);
            }

        }
    }
    // 2번째 업적
    // 3번째 업적
    // 4번째 업적
    // 5번째 업적
}
