package org.b104.alfredo.schedule.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.b104.alfredo.schedule.domain.Schedule;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@NoArgsConstructor
public class ScheduleDetailDto {
    private Long scheduleId;
    private String scheduleTitle;
    private LocalDate startDate;
    private LocalDate endDate;
    private Boolean startAlarm;
    private String place;
    private LocalTime startTime;
    private LocalTime endTime;
    private Boolean withTime;

    public ScheduleDetailDto(Schedule schedule){
        this.scheduleId = schedule.getScheduleId();
        this.scheduleTitle = schedule.getScheduleTitle();
        this.startDate = schedule.getStartDate();
        this.endDate = schedule.getEndDate();
        this.startAlarm = schedule.getStartAlarm();
        this.place = schedule.getPlace();
        this.startTime = schedule.getStartTime();
        this.endTime = schedule.getEndTime();
        this.withTime = schedule.getWithTime();

    }
}
