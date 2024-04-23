package org.b104.alfredo.routine.controller;

import lombok.RequiredArgsConstructor;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.response.RoutineDto;
import org.b104.alfredo.routine.service.RoutineService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

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

    @GetMapping("/{id}")
    public ResponseEntity<RoutineDto> getRoutine(@PathVariable Long id){
        Routine routine = routineService.getRoutine(id);
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
}
