package org.b104.alfredo.achieve.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.repository.AchieveRepository;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.coin.domain.Coin;
import org.b104.alfredo.coin.repository.CoinRepository;
import org.b104.alfredo.firebase.service.FCMAlarmService;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.todo.domain.Day;
import org.b104.alfredo.todo.domain.Time;
import org.b104.alfredo.todo.domain.Todo;
import org.b104.alfredo.todo.repository.DayRepository;
import org.b104.alfredo.todo.repository.TimeRepository;
import org.b104.alfredo.todo.repository.TodoRepository;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Repository.UserRepository;
import org.b104.alfredo.user.Service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.Date;
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
    private final FCMAlarmService fcmAlarmService;
    private final TimeRepository timeRepository;

    // LocalDate를 Date로 변환하는 유틸리티 메서드
    private Date convertToDate(LocalDate localDate) {
        return Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    // 생성
    @Transactional
    public Achieve createAchieve(User user) {
        Achieve newAchieve = Achieve.builder()
                .user(user)
                .achieveOne(false)
                .finishOne(null)
                .achieveTwo(false)
                .finishTwo(null)
                .achieveThree(false)
                .finishThree(null)
                .achieveFour(false)
                .finishFour(null)
                .achieveFive(false)
                .finishFive(null)
                .achieveSix(false)
                .finishSix(null)
                .achieveSeven(false)
                .finishSeven(null)
                .achieveEight(false)
                .finishEight(null)
                .achieveNine(false)
                .finishNine(null)
                .build();

        return achieveRepository.save(newAchieve);
    }

    // 유저로 업적 찾기
    @Transactional
    public AchieveDetailDto getAchieveDetail(User user) {
        Achieve achieve = achieveRepository.findByUser(user);
        if (achieve == null) {
            return null;
        }
        return new AchieveDetailDto(achieve);
    }

    // 첫번째 업적 - 총 시간 합계
    @Transactional
    public boolean checkTimeTodo(String uid) {
        Time time = timeRepository.findByUid(uid);
        User user = userService.getUserByUid(uid);

        Achieve achieve = achieveRepository.findByUser(user);
        if (time.getSumTime() < 30 || achieve == null || achieve.getAchieveOne()) {
            return false;
        }

        achieve.updateAchieveOne(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "첫번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return true;
    }

    // 첫번째 업적 - 총 시간 합계 - 백엔드에서 체크
    @Transactional
    public boolean checkTime(String uid) {

        User user = userService.getUserByUid(uid);
        Achieve achieve = achieveRepository.findByUser(user);
        if (achieve.getAchieveOne()) {
            return false;
        }
        achieve.updateAchieveOne(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "첫번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return true;
    }

    // 두번째 업적 - 첫 ical 등록
    @Transactional
    public boolean checkFirstIcal(User user) {
        Achieve achieve = achieveRepository.findByUser(user);
        // 사용자가 두 번째 업적을 이미 달성한 경우 false 반환
        if (achieve.getAchieveTwo()) {
            return false;
        }

        // 사용자가 Google Calendar URL을 등록하지 않았거나 업적 기록이 없는 경우 false 반환
        if (user.getGoogleCalendarUrl() == null) {
            return false;
        }
        // 두 번째 업적을 달성한 경우 업적 업데이트 및 코인 추가
        achieve.updateAchieveTwo(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }

        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "2번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }

    // 3번째 업적 - day 풀 참가
    @Transactional
    public boolean checkWeekendTodo(String uid) {
        long dayCount = dayRepository.countByUid(uid);
        User user = userService.getUserByUid(uid);

        Achieve achieve = achieveRepository.findByUser(user);
        if (dayCount < 7 || achieve == null || achieve.getAchieveThree()) {
            return false;
        }
        System.out.println("day 풀");
        System.out.println(dayCount);
        achieve.updateAchieveThree(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "3번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }

    // 4번째 업적 - 총 루틴 갯수
    @Transactional
    public boolean checkTotalRoutine(User user) {
        long routineCount = routineRepository.countByUserUserId(user.getUserId());

        Achieve achieve = achieveRepository.findByUser(user);
        if (routineCount < 2 || achieve == null || achieve.getAchieveFour()) {
            return false;
        }

        achieve.updateAchieveFour(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "4번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }
    // 4번째 업적
    // 리스트로 사용하지 않고 count함수 사용하기
//    @Transactional
//    public boolean checkTotalRoutine(User user) {
//        List<Routine> routines = routineRepository.findByUserUserIdOrderByStartTimeAsc(user.getUserId());
//
//        int count = routines.size();
//        Achieve achieve = achieveRepository.findByUser(user);
//        if (count < 2 || achieve == null || achieve.getAchieveFour()) {
//            return false;
//        }
//
//        achieve.updateAchieveFour(true, convertToDate(LocalDate.now()));
//        Coin coin = coinRepository.findByUserId(user);
//        if (coin != null) {
//            coin.updateTotalCoin(coin.getTotalCoin() + 10);
//        }
//        return true;
//    }
    // 5번째 업적 - 총 투두 갯수
    @Transactional
    public boolean checkTotalTodo(String uid) {
        long todoCount = todoRepository.countByUid(uid);
        User user = userService.getUserByUid(uid);

        Achieve achieve = achieveRepository.findByUser(user);
        if (todoCount < 5 || achieve == null || achieve.getAchieveFive()) {
            return false;
        }

        achieve.updateAchieveFive(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "5번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }

    // 6번째 업적 체크 로직 - 총 일정의 갯수
    @Transactional
    public boolean checkTotalSchedule(User user) {
        long scheduleCount = scheduleRepository.countByUserId(user);
        Achieve achieve = achieveRepository.findByUser(user);
        if (scheduleCount < 5 || achieve == null || achieve.getAchieveSix()) {
            return false;
        }

        achieve.updateAchieveSix(true, convertToDate(LocalDate.now()));
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + 10);
        }
        // FCM 알림 전송
        try {
            fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "6번째 ");
        } catch (IOException e) {
            e.printStackTrace();
        }

        return true;
    }

    // 9번째 업적 - 생일인 경우
    @Transactional
    public boolean checkBirth(User user) {
        Achieve achieve = achieveRepository.findByUser(user);

        if (user.getBirth() == null || achieve == null || achieve.getAchieveNine()) {
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
            achieve.updateAchieveNine(true, convertToDate(LocalDate.now()));
            Coin coin = coinRepository.findByUserId(user);
            if (coin != null) {
                coin.updateTotalCoin(coin.getTotalCoin() + 10);
            }
            // FCM 알림 전송
            try {
                fcmAlarmService.sendMessageToAchieve(user.getFcmToken(), "업적 달성!", "9번째 ");
            } catch (IOException e) {
                e.printStackTrace();
            }

            return true;
        }

        return false;
    }
}
