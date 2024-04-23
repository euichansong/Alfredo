package org.b104.alfredo.routine.domain;

import io.micrometer.core.annotation.Counted;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

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
    private LocalTime startTime;

    //TODO LAZY로 바꾸기(서비스 메서드에 트랜잭셔널 걸어야 될 수도)
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "routine_days", joinColumns = @JoinColumn(name = "routine_id"))
    @Column(name="days")
    private Set<String> days = new HashSet<>();

    @Column(name="alarm_sound")
    private String alarmSound;

    @Column(nullable = true)
    private String memo;

    // 요일을 추가하는 메소드
    public void addDay(String day) {
        this.days.add(day);
    }

    // 요일을 삭제하는 메소드
    public void removeDay(String day) {
        this.days.remove(day);
    }


}
