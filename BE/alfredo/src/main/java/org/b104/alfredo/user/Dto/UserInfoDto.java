package org.b104.alfredo.user.Dto;

import lombok.*;
import org.b104.alfredo.user.Domain.User;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserInfoDto {
    private String email;
    private String nickname;
//    private String uid;
    private Date birth;
    private String answer;
    private String google_calendar_url;


    public User toEntity() {
        return User.builder()
                .email(this.email)
                .nickname(this.nickname)
//                .uid(this.uid)
                .birth(this.birth)
                .answer(this.answer)
                .google_calendar_url(this.google_calendar_url)
                .build();
    }
}
