package org.b104.alfredo.firebase.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.firebase.request.FCMAlarmDto;
import org.b104.alfredo.firebase.service.FCMAlarmService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/alarm")
public class FCMAlarmController {

    private final FCMAlarmService fcmAlarmService;

    // POST 요청을 통해 FCM 메시지를 스케줄링합니다.
    @PostMapping("/send")
    public ResponseEntity<String> pushMessage(@RequestBody FCMAlarmDto requestDTO) {
        try {
            // FCMAlarmService의 scheduleMessage 메소드를 호출하여 메시지 스케줄링
            fcmAlarmService.scheduleMessage(
                    requestDTO.getTargetToken(),
                    requestDTO.getTitle(),
                    requestDTO.getBody()
            );
            return ResponseEntity.ok("Message scheduled successfully");
        } catch (Exception e) {
            log.error("Failed to schedule message", e);
            return ResponseEntity.internalServerError().body("Failed to schedule message: " + e.getMessage());
        }
    }
}
