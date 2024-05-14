package org.b104.alfredo.achieve.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.repository.AchieveRepository;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.coin.domain.Coin;
import org.b104.alfredo.coin.repository.CoinRepository;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.todo.domain.Day;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.DayRepository;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Repository.UserRepository;
import org.b104.alfredo.user.Service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.Calendar;
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
    private final UserService userService;
    private final DayRepository dayRepository;

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
    // 두번째 업적 - 첫 ical 등록
    public boolean checkFirstIcal(User user) {
        Achieve achieve = achieveRepository.findByUser(user);

        if (user.getGoogleCalendarUrl() == null || achieve == null || achieve.getAchieveOne()) {
            return false;
        }

        achieve.updateAchieveTwo(true);
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        return true;
    }

    // 3번째 업적 - day 풀 참가
    @Transactional
    public boolean checkWeekendTodo(String uid) {
        List<Day> weekend = dayRepository.findAllByUid(uid);
        User user = userService.getUserByUid(uid);

        int count = weekend.size();
        Achieve achieve = achieveRepository.findByUser(user);
        // 업적 달성에 필요한 갯수
        if (count < 7 || achieve == null || achieve.getAchieveThree()) {
            return false;
        }

        achieve.updateAchieveThree(true);
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        return true;
    }


    // 4번째 업적 - 총 루틴 갯수
    @Transactional
    public boolean checkTotalRoutine(User user) {
        List<Routine> routines = routineRepository.findByUserUserIdOrderByStartTimeAsc(user.getUserId());

        int count = routines.size();
        Achieve achieve = achieveRepository.findByUser(user);
        // 업적 달성에 필요한 갯수
        if (count < 2 || achieve == null || achieve.getAchieveFour()) {
            return false;
        }

        achieve.updateAchieveFour(true);
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        return true;
    }

    // 5번째 업적 - 총 투두 갯수
    @Transactional
    public boolean checkTotalTodo(String uid) {
        List<Todo> todos = todoRepository.findAllByUid(uid);
        User user = userService.getUserByUid(uid);

        int count = todos.size();
        Achieve achieve = achieveRepository.findByUser(user);
        // 업적 달성에 필요한 갯수
        if (count < 2 || achieve == null || achieve.getAchieveFive()) {
            return false;
        }

        achieve.updateAchieveFive(true);
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        return true;
    }

    // 6번째 업적 체크 로직 -  - 총 일정의 갯수
    @Transactional
    public boolean checkTotalSchedule(User user) {
        List<Schedule> schedules = scheduleRepository.findByUserId(user);

        int count = schedules.size();
        Achieve achieve = achieveRepository.findByUser(user);
        // 업적 달성에 필요한 갯수
        if (count < 2 || achieve == null || achieve.getAchieveSix()) {
            return false;
        }

        achieve.updateAchieveSix(true);
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        return true;
    }

    // 9번째 업적 - 생일인 경우
    @Transactional
    public boolean checkBirth(User user) {
        Achieve achieve = achieveRepository.findByUser(user);

        if (user.getBirth() == null || achieve == null || achieve.getAchieveOne()) {
            return false;
        }

        // 현재 날짜의 월과 일을 추출
        LocalDate today = LocalDate.now();
        int todayMonth = today.getMonthValue();
        int todayDay = today.getDayOfMonth();

        // 유저 생일의 월과 일을 추출
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(user.getBirth());
        int birthMonth = calendar.get(Calendar.MONTH) + 1; // Calendar.MONTH는 0부터 시작하므로 1을 더해줍니다.
        int birthDay = calendar.get(Calendar.DAY_OF_MONTH);

        // 생일이 오늘인지 확인
        if (todayMonth == birthMonth && todayDay == birthDay) {
            achieve.updateAchieveNine(true);
            Coin coin = coinRepository.findByUserId(user);
            if (coin != null) {
                coin.updateTotalCoin(coin.getTotalCoin() + 10);
            }
            return true;
        }

        return false;
    }
}