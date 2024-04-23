package org.b104.alfredo.routine.response;

import jakarta.persistence.Column;
import lombok.*;

import java.time.LocalDateTime;
@Getter @Setter
@NoArgsConstructor
@ToString
public class RoutineDto {
    private Long id;
    private String routineTitle;
    private LocalDateTime startTime;
    private Integer day;
    private String alarmSound;
    private String memo;

    @Builder
    public RoutineDto(Long id,String routineTitle,LocalDateTime startTime,Integer day,String alarmSound,String memo){
        this.id= id;
        this.routineTitle = routineTitle;
        this.startTime = startTime;
        this.day = day;
        this.alarmSound = alarmSound;
        this.memo = memo;
    }
}
