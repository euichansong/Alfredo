package org.b104.alfredo.todo.request;


import lombok.*;
import org.b104.alfredo.todo.domain.Todo;
import java.time.LocalDate;
import java.util.Optional;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TodoUpdateSubDto {
    private Long id;
    private String subIndex; // 추가 인덱스, 필요에 따라 제외 가능
    private String todoTitle; // 할 일 제목
    private LocalDate date;
}