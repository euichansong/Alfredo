package org.b104.alfredo.schedule.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.schedule.request.ScheduleCreateDto;
import org.b104.alfredo.schedule.request.ScheduleUpdateDto;
import org.b104.alfredo.schedule.response.ScheduleDetailDto;
import org.b104.alfredo.schedule.response.ScheduleListDto;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;
    private final UserRepository userRepository;

    // 생성
    @Transactional
    public Schedule create(ScheduleCreateDto scheduleCreateDto, User user){
        Schedule schedule = Schedule.builder()
                .userId(user)
                .scheduleTitle(scheduleCreateDto.getScheduleTitle())
                .startDate(scheduleCreateDto.getStartDate())
                .endDate(scheduleCreateDto.getEndDate())
                .startAlarm(scheduleCreateDto.getStartAlarm())
                .place(scheduleCreateDto.getPlace())
                .startTime(scheduleCreateDto.getStartTime())
                .endTime(scheduleCreateDto.getEndTime())
                .withTime(scheduleCreateDto.getWithTime())
                .build();
        return scheduleRepository.save(schedule);
    }
    // 조회
    @Transactional
    public List<ScheduleListDto> findAllByUser(User user) {
        List<Schedule> schedules = scheduleRepository.findByUserId(user);
        return schedules.stream()
                .map(ScheduleListDto::new)
                .collect(Collectors.toList());
    }
    // 상세조회
    @Transactional
    public ScheduleDetailDto findScheduleById(Long id) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
        return new ScheduleDetailDto(schedule);
    }
    // 삭제
    @Transactional
    public void deleteSchedule(Long id) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
        scheduleRepository.delete(schedule);
    }
    // 수정
    @Transactional
    public void updateSchedule(Long id, ScheduleUpdateDto dto) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Schedule not found for id=" + id));
        updateScheduleEntity(schedule, dto);
        scheduleRepository.save(schedule);
    }

    public static void updateScheduleEntity(Schedule schedule, ScheduleUpdateDto scheduleUpdateDto) {
        if (scheduleUpdateDto.getScheduleTitle() != null) schedule.setScheduleTitle(scheduleUpdateDto.getScheduleTitle());
        if (scheduleUpdateDto.getStartDate() != null) schedule.setStartDate(scheduleUpdateDto.getStartDate());
        if (scheduleUpdateDto.getEndDate() != null) schedule.setEndDate(scheduleUpdateDto.getEndDate());
        if (scheduleUpdateDto.getStartAlarm() != null) schedule.setStartAlarm(scheduleUpdateDto.getStartAlarm());
        if (scheduleUpdateDto.getPlace() != null) schedule.setPlace(scheduleUpdateDto.getPlace());
        if (scheduleUpdateDto.getStartTime() != null) schedule.setStartTime(scheduleUpdateDto.getStartTime());
        if (scheduleUpdateDto.getEndTime() != null) schedule.setEndTime(scheduleUpdateDto.getEndTime());
        if (scheduleUpdateDto.getWithTime() != null) schedule.setWithTime(scheduleUpdateDto.getWithTime());
    }

}
