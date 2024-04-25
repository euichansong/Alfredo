package org.b104.alfredo.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;

@Component
public class FirebaseInitializer {

    @PostConstruct
    public void initialize() {
        try {
            // 환경변수에서 Firebase 설정 파일의 경로를 읽어옵니다.
            FileInputStream serviceAccount =
                    new FileInputStream("C:\\Users\\SSAFY\\Desktop\\final_be\\S10P31B104\\BE\\alfredo\\alfredo104-firebase-adminsdk-qhdta-be4ef2b790.json");
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
