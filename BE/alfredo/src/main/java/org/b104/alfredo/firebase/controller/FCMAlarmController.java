package org.b104.alfredo.firebase.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.firebase.request.FCMAlarmDto;
import org.b104.alfredo.firebase.service.FCMAlarmService;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("api/alarm")
public class FCMAlarmController {

    private final FCMAlarmService fcmAlarmService;
    private final UserService userService;

    @PostMapping("/send")
    public ResponseEntity<String> sendAlarm(@RequestHeader(value = "Authorization") String authHeader,
                                            @RequestBody FCMAlarmDto fcmAlarmDto) {
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            User user = userService.getUserByUid(decodedToken.getUid());

            String result = fcmAlarmService.sendNotificationByToken(user, fcmAlarmDto);
            return new ResponseEntity<>("Notification sent successfully. Message ID: " + result, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Failed to send notification", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to send notification. Error: " + e.getMessage());
        }
    }


}
