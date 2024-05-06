package org.b104.alfredo.firebase.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.RequiredArgsConstructor;
import org.b104.alfredo.config.FirebaseInitializer;
import org.b104.alfredo.firebase.request.FCMAlarmDto;
import org.b104.alfredo.user.Domain.User;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FCMAlarmService {
    private final FirebaseMessaging firebaseMessaging;
    public String sendNotificationByToken(User user, FCMAlarmDto requestDto) {
        Notification notification = Notification.builder()
                .setTitle(requestDto.getTitle())
                .setBody(requestDto.getBody())
                .build();

        Message message = Message.builder()
                .setToken(user.getUid())
                .setNotification(notification)
                .build();

        try {
            return firebaseMessaging.send(message);
        } catch (FirebaseMessagingException e) {
            throw new RuntimeException("Failed to send notification. Error: " + e.getMessage());
        }
    }
}
