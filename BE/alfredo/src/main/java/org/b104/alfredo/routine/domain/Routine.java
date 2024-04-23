package org.b104.alfredo.routine.domain;

import io.micrometer.core.annotation.Counted;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "routine")
@Getter @Setter
public class Routine {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="routine_id")
    private Long id;
    @Column(name="routine_title")
    private String routineTitle;

    @Column(name="start_time")
    private LocalDateTime startTime;

    @Column(name="day")
    private Integer day;

    @Column(name="alarm_sound")
    private String alarmSound;

    @Column(nullable = true)
    private String memo;




}
