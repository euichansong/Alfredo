package org.b104.alfredo.todo.domain;
import jakarta.persistence.Entity;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;


@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(nullable = false)
    private Long userId;
    private Long subIndex;
    @Column(nullable = false, length = 255)
    private String todoTitle;
    private String todoContent;
    @Column(nullable = false)
    private LocalDate dueDate;
    private Integer spentTime;
    private Boolean isCompleted;
    private String url;
    private String place;
}
