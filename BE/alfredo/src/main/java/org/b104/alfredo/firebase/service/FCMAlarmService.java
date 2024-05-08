package org.b104.alfredo.firebase.service;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.b104.alfredo.firebase.domain.FcmMessage;
import org.b104.alfredo.jobs.FcmJob;
import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.Date;
import java.util.List;

@Service
public class FCMAlarmService {

    @Value("${firebase.api.url}")
    private String API_URL;
    private final ObjectMapper objectMapper;
    private Scheduler scheduler;

    @Autowired
    private ApplicationContext applicationContext; // ApplicationContext 주입

    @Value("${firebase.sdk}")
    private String firebaseConfigPath;

    public FCMAlarmService(ObjectMapper objectMapper) throws SchedulerException {
        this.objectMapper = objectMapper;
        this.scheduler = StdSchedulerFactory.getDefaultScheduler();
        scheduler.start();
    }

    // 메시지를 스케줄링하는 메소드
    public void scheduleMessage(String targetToken, String title, String body) throws SchedulerException {

        System.out.println("scheduleMessage called");
        String uniqueIdentifier = targetToken + "-" + System.currentTimeMillis(); // 고유 식별자 생성
        JobDetail jobDetail = JobBuilder.newJob(FcmJob.class)
                .withIdentity(uniqueIdentifier, "FCM-Messages") // 고유 식별자 사용
                .usingJobData("targetToken", targetToken)
                .usingJobData("title", title)
                .usingJobData("body", body)
                .build();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime scheduleTime = LocalDateTime.parse(body, formatter);
        Date startAt = Date.from(scheduleTime.atZone(ZoneId.systemDefault()).toInstant());
        System.out.println("start date");
        System.out.println(startAt);
        Trigger trigger = TriggerBuilder.newTrigger()
                .withIdentity("trigger-" + uniqueIdentifier, "FCM-Messages")
                .startAt(startAt)
                .build();
        System.out.println(trigger);
        System.out.println(jobDetail);
        scheduler.scheduleJob(jobDetail, trigger);
    }

    // 실제 FCM 메시지를 구성하고 전송하는 메소드
    public void sendMessageTo(String targetToken, String title, String body) throws IOException {
        String message = makeMessage(targetToken, title, body);

        System.out.println("message");
        System.out.println(message);
        OkHttpClient client = new OkHttpClient();
        MediaType mediaType = MediaType.get("application/json; charset=utf-8");
        RequestBody requestBody = RequestBody.create(message, mediaType);

        Request request = new Request.Builder()
                .url(API_URL)
                .post(requestBody)
                .addHeader("Authorization", "Bearer " + getAccessToken())
                .addHeader("Content-Type", "application/json; charset=utf-8")
                .build();

        try (Response response = client.newCall(request).execute()) {
            System.out.println(response.isSuccessful() ? response.body().string() : "Failed with status: " + response.code());
        }
    }
    // FCM 메시지 형식을 생성하는 메소드
    private String makeMessage(String targetToken, String title, String body) throws JsonParseException, IOException {
        FcmMessage fcmMessage = FcmMessage.builder()
                .message(FcmMessage.Message.builder()
                        .token(targetToken)
                        .notification(FcmMessage.Notification.builder()
                                .title(title)
                                .body(body)
                                .image(null)
                                .build())
                        .build())
                .validateOnly(false)
                .build();
        System.out.println("makeMessage");
        System.out.println(fcmMessage);
        return objectMapper.writeValueAsString(fcmMessage);
    }

    // Google API 토큰을 얻는 메소드
    private String getAccessToken() throws IOException {
        // Firebase 설정 파일을 사용하여 GoogleCredentials 객체를 생성
        GoogleCredentials googleCredentials = GoogleCredentials
                .fromStream(new FileSystemResource(firebaseConfigPath).getInputStream())
                .createScoped(Collections.singletonList("https://www.googleapis.com/auth/cloud-platform"));

        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }
}
