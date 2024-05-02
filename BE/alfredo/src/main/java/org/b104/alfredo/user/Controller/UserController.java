package org.b104.alfredo.user.Controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Dto.UserCreateDto;
import org.b104.alfredo.user.Dto.UserUpdateDto;
import org.b104.alfredo.user.Service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;



@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {
    private static final Logger log = LoggerFactory.getLogger(UserController.class);

    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestHeader(value = "Authorization") String authHeader) {
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        System.out.println("Received token: " + idToken);
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);

            String uid = decodedToken.getUid();
            System.out.println("Token UID: " + uid);
            User user = userService.getUserByUid(uid);

            if (user == null) {
                UserCreateDto userCreateDto = new UserCreateDto();
                userCreateDto.setEmail(decodedToken.getEmail());
                userCreateDto.setUid(uid);
                userCreateDto.setNickname("default_nickname");

                user = userService.createUser(userCreateDto);
                return ResponseEntity.status(HttpStatus.CREATED).body(user);
            } else {
                return ResponseEntity.ok(user);
            }
        } catch (Exception e) {
            // 토큰이 유효하지 않거나 다른 오류가 발생한 경우, 예외의 상세한 원인을 로그에 포함하여 무단 상태로 반환
            log.error("Token verification failed: {}", e.getMessage(), e);

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }


    @GetMapping
    public ResponseEntity<?> getUser(@RequestHeader(value = "Authorization") String authHeader) {
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            if (user != null) {
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_JSON);
                return new ResponseEntity<>(user, headers, HttpStatus.OK);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }
        } catch (Exception e) {
            log.error("Error verifying token: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token");
        }
    }

    @PutMapping("/update")
    public ResponseEntity<?> updateUser(
            @RequestHeader(value = "Authorization") String authHeader,
            @RequestBody UserUpdateDto userUpdateDto) {
        String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;

        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User updatedUser = userService.updateUser(uid, userUpdateDto);

            return ResponseEntity.ok(updatedUser);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid token or user not found");
        }
    }
}