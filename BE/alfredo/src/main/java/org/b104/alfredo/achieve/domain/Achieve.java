package org.b104.alfredo.achieve.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.b104.alfredo.user.Domain.User;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Getter
@NoArgsConstructor
public class Achieve {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long achieveId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id" )
    private User user;    // 유저 아이디
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveOne;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveTwo;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveThree;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveFour;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveFive;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveSix;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveSeven;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveEight;
    // false가 기본
    @ColumnDefault("false")
    private Boolean achieveNine;


    @Builder
    public Achieve(User user, Boolean achieveOne, Boolean achieveTwo, Boolean achieveThree, Boolean achieveFour, Boolean achieveFive, Boolean achieveSix, Boolean achieveSeven, Boolean achieveEight, Boolean achieveNine) {
        this.user = user;
        this.achieveOne = achieveOne;
        this.achieveTwo = achieveTwo;
        this.achieveThree = achieveThree;
        this.achieveFour = achieveFour;
        this.achieveFive = achieveFive;
        this.achieveSix = achieveSix;
        this.achieveSeven = achieveSeven;
        this.achieveEight = achieveEight;
        this.achieveNine = achieveNine;
    }

    public void updateAchieveOne(Boolean achieveOne) {
        this.achieveOne = achieveOne;
    }

    public void updateAchieveTwo(Boolean achieveTwo) {
        this.achieveTwo = achieveTwo;
    }

    public void updateAchieveThree(Boolean achieveThree) {
        this.achieveThree = achieveThree;
    }

    public void updateAchieveFour(Boolean achieveFour) {
        this.achieveFour = achieveFour;
    }

    public void updateAchieveFive(Boolean achieveFive) {
        this.achieveFive = achieveFive;
    }

    public void updateAchieveSix(Boolean achieveSix) {
        this.achieveSix = achieveSix;
    }

    public void updateAchieveSeven(Boolean achieveSeven) {
        this.achieveSeven = achieveSeven;
    }

    public void updateAchieveEight(Boolean achieveEight) {
        this.achieveEight = achieveEight;
    }

    public void updateAchieveNine(Boolean achieveNine) {
        this.achieveNine = achieveNine;
    }
}
