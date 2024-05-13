package org.b104.alfredo.achieve.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.achieve.service.AchieveService;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/achieve")
public class AchieveController {
    private final AchieveService achieveService;
    private final UserService userService;

    // 사용자 ID를 기반으로 업적 생성
    @PostMapping("/create")
    public ResponseEntity<Object> createAchieve(@RequestHeader(value = "Authorization") String authHeader) {
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            AchieveDetailDto existingAchieve = achieveService.getAchieveDetail(user);

            if (existingAchieve != null) {
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Achieve already exists for this user.");
            }

            Achieve newAchieve = achieveService.createAchieve(user);
            return ResponseEntity.ok(new AchieveDetailDto(newAchieve));
        } catch (Exception e) {
            log.error("Failed to create achieve", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // 조회
    @GetMapping("/detail")
    public ResponseEntity<AchieveDetailDto> findAchieveDetail(@RequestHeader(value = "Authorization") String authHeader) {
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            AchieveDetailDto achieveDetail = achieveService.getAchieveDetail(user);

            return new ResponseEntity<>(achieveDetail, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error fetching achieve details", e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }

    // 6번째 업적 - 총 일정의 갯수
    @PostMapping("/six")
    public ResponseEntity<String> checkSchedulesAchieve(@RequestHeader(value = "Authorization") String authHeader) {
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            achieveService.checkTotalSchedule(user);

            return ResponseEntity.ok("Achievement status updated successfully.");
        } catch (Exception e) {
            log.error("Failed to update achievement status", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

}
