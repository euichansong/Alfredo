package org.b104.alfredo.schedule.service;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.schedule.domain.Schedule;
import org.b104.alfredo.schedule.repository.ScheduleRepository;
import org.b104.alfredo.schedule.request.ScheduleCreateDto;
import org.b104.alfredo.schedule.request.ScheduleUpdateDto;
import org.b104.alfredo.schedule.response.ScheduleDetailDto;
import org.b104.alfredo.schedule.response.ScheduleListDto;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    @Transactional
    public Long create(ScheduleCreateDto scheduleCreateDto){
        return scheduleRepository.save(scheduleCreateDto.toEntity()).getScheduleId();
    }

    @Transactional
    public List<ScheduleListDto> findAllSchedule(){
        List<Schedule> schedules = scheduleRepository.findAll();
        return schedules.stream()
                .map(ScheduleListDto::new)
                .collect(Collectors.toList());
    }

    @Transactional
    public ScheduleDetailDto findScheduleById(Long id) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
        return new ScheduleDetailDto(schedule);
    }

    @Transactional
    public void deleteSchedule(Long id) {
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 스케줄이 없습니다. id=" + id));
        scheduleRepository.delete(schedule);
    }

    @Transactional
    public Long scheduleUpdate(Long id, ScheduleUpdateDto scheduleUpdateDto){
        Schedule schedule = scheduleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("해당 게시글이 없습니다. id="+ id));

        schedule.scheduleUpdate(scheduleUpdateDto.getScheduleTitle(),
                scheduleUpdateDto.getStartDate(),
                scheduleUpdateDto.getEndDate(),
                scheduleUpdateDto.getStartAlarm(),
                scheduleUpdateDto.getPlace(),
                scheduleUpdateDto.getStartTime(),
                scheduleUpdateDto.getEndTime(),
                scheduleUpdateDto.getWithTime()
                );
        return id;
    }



}
