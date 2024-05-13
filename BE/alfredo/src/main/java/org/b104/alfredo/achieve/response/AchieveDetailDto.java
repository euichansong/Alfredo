package org.b104.alfredo.achieve.response;

import lombok.Getter;
import lombok.NoArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;


@Getter
@NoArgsConstructor
public class AchieveDetailDto {

    private Long achieveId;
    private Boolean achieveOne;
    private Boolean achieveTwo;
    private Boolean achieveThree;
    private Boolean achieveFour;
    private Boolean achieveFive;
    private Boolean achieveSix;
    private Boolean achieveSeven;
    private Boolean achieveEight;
    private Boolean achieveNine;

    public AchieveDetailDto(Achieve achieve){
        this.achieveId = achieve.getAchieveId();
        this.achieveOne = achieve.getAchieveOne();
        this.achieveTwo = achieve.getAchieveTwo();
        this.achieveThree = achieve.getAchieveThree();
        this.achieveFour = achieve.getAchieveFour();
        this.achieveFive = achieve.getAchieveFive();
        this.achieveSix = achieve.getAchieveSix();
        this.achieveSeven = achieve.getAchieveSeven();
        this.achieveEight = achieve.getAchieveEight();
        this.achieveNine = achieve.getAchieveNine();
    }

}
