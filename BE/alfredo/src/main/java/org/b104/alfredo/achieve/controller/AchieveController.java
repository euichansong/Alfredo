package org.b104.alfredo.achieve.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.request.AchieveUpdateDto;
import org.b104.alfredo.achieve.service.AchieveService;
import org.b104.alfredo.schedule.response.ScheduleListDto;
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

    // 조회
    @GetMapping("/list")
    public ResponseEntity<Achieve> findAchieve(@RequestHeader(value = "Authorization") String authHeader){
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            Achieve achieve = achieveService.findByUserId(user);

            return new ResponseEntity<>(achieve, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Failed to read schedule list", e);
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

//    // 수정
//    @PatchMapping("/update")
//    public ResponseEntity<Void> updateAchieve(@RequestHeader(value = "Authorization") String authHeader,
//                                              @RequestBody AchieveUpdateDto achieveUpdateDto){
//        try {
//            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
//            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
//            String uid = decodedToken.getUid();
//
//            User user = userService.getUserByUid(uid);
//            // user 통채로 들고 가서 조회?
//
//            return ResponseEntity.ok().build();
//        } catch (Exception e) {
//            log.error("Failed to read schedule list", e);
//            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
//        }
//    }

}
