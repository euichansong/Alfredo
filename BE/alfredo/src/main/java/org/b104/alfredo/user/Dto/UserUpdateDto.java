package org.b104.alfredo.user.Dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.b104.alfredo.user.Domain.User;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
public class UserUpdateDto {
    private String nickname;
    private Date birth;
    private String answer;
    private String google_calendar_url;

    public static void updateEntity(User user, UserUpdateDto userUpdateDto) {
        if (userUpdateDto.getNickname() != null) user.setNickname(userUpdateDto.getNickname());
        if (userUpdateDto.getBirth() != null) user.setBirth(userUpdateDto.getBirth());
        if (userUpdateDto.getAnswer() != null) user.setAnswer(userUpdateDto.getAnswer());
        if (userUpdateDto.getGoogle_calendar_url() != null) user.setGoogle_calendar_url(userUpdateDto.getGoogle_calendar_url());
    }
}
