package org.b104.alfredo.schedule.request;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.b104.alfredo.schedule.domain.Schedule;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@NoArgsConstructor
public class ScheduleCreateDto {

    private String scheduleTitle;
    private LocalDate startDate;
    private LocalDate endDate;
    private Boolean startAlarm;
    private String place;
    private LocalTime startTime;
    private LocalTime endTime;
    private Boolean withTime;

   public Schedule toEntity(){
       return Schedule.builder()
               .scheduleTitle(scheduleTitle)
               .startDate(startDate)
               .endDate(endDate)
               .startTime(startTime)
               .endTime(endTime)
               .startAlarm(startAlarm)
               .place(place)
               .withTime(withTime)
               .build();
   }

}
