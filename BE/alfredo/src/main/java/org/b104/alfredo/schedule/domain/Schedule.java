package org.b104.alfredo.schedule.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Getter
@NoArgsConstructor
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long scheduleId;

    //    // 유저 테이블 만들어 지면 추가
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "user_id" )
//    private Long userId;
    @Column(nullable = false)
    private String scheduleTitle;
    @Column(nullable = false)
    private LocalDate startDate;
    @Column
    private LocalDate endDate;
    // false가 기본
    @ColumnDefault("false")
    private Boolean startAlarm;
    @Column
    private String place;
    @Column
    private LocalTime startTime;
    @Column
    private LocalTime endTime;
    // true가 기본
    @ColumnDefault("true")
    private Boolean withTime;

    @Builder
    public Schedule(String scheduleTitle, LocalDate startDate, LocalDate endDate, Boolean startAlarm, String place, LocalTime startTime, LocalTime endTime, Boolean withTime) {
        this.scheduleTitle = scheduleTitle;
        this.startDate = startDate;
        this.endDate = endDate;
        this.startAlarm = startAlarm != null ? startAlarm : Boolean.FALSE;
        this.place = place;
        this.startTime = startTime;
        this.endTime = endTime;
        this.withTime = withTime != null ? withTime : Boolean.TRUE;
    }

    public void scheduleUpdate(String scheduleTitle, LocalDate startDate, LocalDate endDate, Boolean startAlarm, String place, LocalTime startTime, LocalTime endTime, Boolean withTime) {
        this.scheduleTitle = scheduleTitle;
        this.startDate = startDate;
        this.endDate = endDate;
        this.startAlarm = startAlarm != null ? startAlarm : Boolean.FALSE;
        this.place = place;
        this.startTime = startTime;
        this.endTime = endTime;
        this.withTime = withTime != null ? withTime : Boolean.TRUE;
    }

}
