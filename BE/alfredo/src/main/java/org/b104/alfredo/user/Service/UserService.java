package org.b104.alfredo.user.Service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Dto.UserCreateDto;
import org.b104.alfredo.user.Dto.UserInfoDto;
import org.b104.alfredo.user.Dto.UserUpdateDto;
import org.b104.alfredo.user.Repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {

    private final UserRepository userRepository;


    public User createUser(UserCreateDto userCreateDto) {
        User user = User.builder()
                .email(userCreateDto.getEmail())
                .uid(userCreateDto.getUid())
                .build();

        user = userRepository.save(user);

        user.setNickname("사용자" + user.getUserId());
        return userRepository.save(user);
    }

    public UserInfoDto getUserInfo(String uid) {
        User user = userRepository.findByUid(uid).orElseThrow(() -> new NoSuchElementException("User not found"));

        return new UserInfoDto(
                user.getEmail(),
                user.getNickname(),
//                user.getUid(),
                user.getBirth(),
                user.getAnswer(),
                user.getGoogleCalendarUrl()
        );
    }

    public User updateUser(String uid, UserUpdateDto userUpdateDto) {
        User user = userRepository.findByUid(uid).orElseThrow(() ->
                new NoSuchElementException("User not found with uid: " + uid));

        UserUpdateDto.updateEntity(user, userUpdateDto);
        return userRepository.save(user);
    }

    public User getUserByUid(String uid) {
        return userRepository.findByUid(uid).orElse(null);
    }


}
