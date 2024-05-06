//package org.b104.alfredo.schedule.service;
//
//import com.google.firebase.messaging.FirebaseMessaging;
//import com.google.firebase.messaging.FirebaseMessagingException;
//import com.google.firebase.messaging.Message;
//import com.google.firebase.messaging.Notification;
//import lombok.RequiredArgsConstructor;
//import org.b104.alfredo.schedule.domain.Schedule;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.stereotype.Service;
//
//import java.time.LocalDate;
//import java.time.LocalTime;
//import java.util.List;
//
//@Service
//@RequiredArgsConstructor
//public class ScheduleAlarmService {
//
//    private final FirebaseMessaging firebaseMessaging;
//
//    @Value("${firebase.device.token}")
//    private String deviceToken;
//
//    public void sendScheduledNotifications(List<Schedule> schedules) {
//        for (Schedule schedule : schedules) {
//            if (schedule.getStartAlarm() && shouldSendNotification(schedule)) {
//                sendNotification(schedule);
//            }
//        }
//    }
//
//    private boolean shouldSendNotification(Schedule schedule) {
//        LocalDate currentDate = LocalDate.now();
//        LocalTime currentTime = LocalTime.now();
//        // startDate의 날짜와 alarmTime을 비교하여 알림을 보낼지 결정합니다.
//        return currentDate.isEqual(schedule.getStartDate())
//                && currentTime.isAfter(schedule.getAlarmTime());
//    }
//    private void sendNotification(Schedule schedule) {
//        Notification notification = Notification.builder()
//                .setTitle("일정 알림")
//                .setBody(schedule.getScheduleTitle() + " 일정이 시작합니다.")
//                .build();
//        Message message = Message.builder()
//                .setNotification(notification)
//                .setToken(deviceToken)
//                .build();
//        try {
//            firebaseMessaging.send(message);
//        } catch (FirebaseMessagingException e) {
//            // 알림 전송 실패 처리
//            e.printStackTrace();
//        }
//    }
//
//}