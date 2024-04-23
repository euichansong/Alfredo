package org.b104.alfredo.routine.response;

import jakarta.persistence.Column;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Set;

@Getter @Setter
@NoArgsConstructor
@ToString
public class RoutineDto {
    private Long id;
    private String routineTitle;
    private LocalDateTime startTime;
    private Set<String> days;
    private String alarmSound;
    private String memo;

    @Builder
    public RoutineDto(Long id,String routineTitle,LocalDateTime startTime,Set<String> days,String alarmSound,String memo){
        this.id= id;
        this.routineTitle = routineTitle;
        this.startTime = startTime;
        this.days = days;
        this.alarmSound = alarmSound;
        this.memo = memo;
    }
}
