package org.b104.alfredo.user.Domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false, unique = true)
    private String email;

    @Column
    private String nickname;

    @Column(nullable = false)
    private String uid;

    @Column
    private Date birth;

    @Lob
    private String answer;

    @Column
    private String google_calendar_url;

    @Column(nullable = false)
    private LocalDateTime registeredAt;

    @PrePersist
    protected void onRegister() {
        this.registeredAt = LocalDateTime.now();
    }

}
