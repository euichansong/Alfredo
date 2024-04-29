package org.b104.alfredo.todo.request;

import lombok.*;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TodoCreateDto {
    private Long subIndex;
    private String todoTitle;
    private String todoContent;
    private LocalDate dueDate;
    private Integer spentTime;
    private Boolean isCompleted;
    private String url;
    private String place;
    private String uid; // 사용자의 UID만 참조
}
