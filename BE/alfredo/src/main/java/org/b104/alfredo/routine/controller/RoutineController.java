package org.b104.alfredo.routine.controller;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.repository.RoutineRepository;
import org.b104.alfredo.routine.request.RoutineRequestDto;
import org.b104.alfredo.routine.response.RoutineDto;
import org.b104.alfredo.routine.service.RoutineService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

//TODO Transactional을 해야 되나??
@RestController
@RequestMapping("/routine")
@RequiredArgsConstructor
public class RoutineController {
    private final RoutineService routineService;
    private final Logger log = LoggerFactory.getLogger(RoutineController.class);
    @GetMapping("/all")
    public ResponseEntity<List<RoutineDto>> getRoutineList() {
        List<Routine> routineList = routineService.getAllRoutines();
        List<RoutineDto> routineDtoList = new ArrayList<>();
        log.info("전체 루틴 정보");
        for (Routine r : routineList) {
            RoutineDto routineDto = RoutineDto.builder()
                    .id(r.getId())
                    .routineTitle(r.getRoutineTitle())
                    .startTime(r.getStartTime())
                    .days(r.getDays())
                    .alarmSound(r.getAlarmSound())
                    .memo(r.getMemo())
                    .build();
            routineDtoList.add(routineDto);
        }
        return ResponseEntity.ok().body(routineDtoList);
    }

    @GetMapping("/{routineId}")
    public ResponseEntity<RoutineDto> getRoutine(@PathVariable Long routineId){
        Routine routine = routineService.getRoutine(routineId);
        RoutineDto routineDto = RoutineDto.builder()
                .id(routine.getId())
                .routineTitle(routine.getRoutineTitle())
                .startTime(routine.getStartTime())
                .days(routine.getDays())
                .alarmSound(routine.getAlarmSound())
                .memo(routine.getMemo())
                .build();
        return ResponseEntity.ok().body(routineDto);
    }

//    String routineTitle, LocalTime startTime, Set<String> days, String alarmSound, String memo
//    routineTitle,startTime,days,alarmSound,memo
    @PostMapping
    public ResponseEntity<RoutineDto> createRoutine(@RequestBody RoutineRequestDto routineRequestDto){
        Routine routine = routineService.createRoutine(routineRequestDto.getRoutineTitle(),routineRequestDto.getStartTime(),routineRequestDto.getDays(),routineRequestDto.getAlarmSound(),routineRequestDto.getMemo());
        RoutineDto routineDto = RoutineDto.builder()
                .id(routine.getId())
                .routineTitle(routine.getRoutineTitle())
                .startTime(routine.getStartTime())
                .days(routine.getDays())
                .alarmSound(routine.getAlarmSound())
                .memo(routine.getMemo())
                .build();
        return ResponseEntity.ok().body(routineDto);
    }

    //TODO Patch로 해보기
    @PutMapping("/{routineId}")
    public ResponseEntity<RoutineDto> updateRoutine(@PathVariable Long routineId,@RequestBody RoutineRequestDto routineRequestDto){
        Routine routine = routineService.updateRoutine(
                routineId,
                routineRequestDto.getRoutineTitle(),
                routineRequestDto.getStartTime(),
                routineRequestDto.getDays(),
                routineRequestDto.getAlarmSound(),
                routineRequestDto.getMemo());

        RoutineDto routineDto = RoutineDto.builder()
                .id(routine.getId())
                .routineTitle(routine.getRoutineTitle())
                .startTime(routine.getStartTime())
                .days(routine.getDays())
                .alarmSound(routine.getAlarmSound())
                .memo(routine.getMemo())
                .build();
        return ResponseEntity.ok().body(routineDto);
    }

    //TODO ruturn값 설정?
    @DeleteMapping("/{routineId}")
    public void deleteRoutine(@PathVariable Long routineId) {
        routineService.deleteRoutine(routineId);
    }
}
