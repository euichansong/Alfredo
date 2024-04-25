package org.b104.alfredo.schedule.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.schedule.request.ScheduleCreateDto;
import org.b104.alfredo.schedule.request.ScheduleUpdateDto;
import org.b104.alfredo.schedule.response.ScheduleDetailDto;
import org.b104.alfredo.schedule.response.ScheduleListDto;
import org.b104.alfredo.schedule.service.ScheduleService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ScheduleController {

    private final ScheduleService scheduleService;

    // 저장
    @PostMapping("/save")
    public Long save(@RequestBody ScheduleCreateDto scheduleCreateDto){
        return scheduleService.create(scheduleCreateDto);
    }

    // 전체 조회
    @GetMapping("/list")
    public List<ScheduleListDto> findAllSchedule(){
        return scheduleService.findAllSchedule();
    }

    // 상세 조회
    @GetMapping("/detail/{id}")
    public ScheduleDetailDto getScheduleById(@PathVariable Long id) {
        return scheduleService.findScheduleById(id);
    }

    // 수정
    @PatchMapping("/detail/{id}")
    public Long update(@PathVariable Long id, @RequestBody ScheduleUpdateDto scheduleUpdateDto) {
        return scheduleService.scheduleUpdate(id, scheduleUpdateDto);
    }

    // 삭제
    @DeleteMapping("/detail/{id}")
    public Long deleteScheduleById(@PathVariable Long id) {
        scheduleService.deleteSchedule(id);
        return id;
    }
}
