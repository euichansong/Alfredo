package org.b104.alfredo.user.Service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import org.b104.alfredo.routine.domain.Routine;
import org.b104.alfredo.routine.response.RoutineDto;
import org.b104.alfredo.user.Domain.Survey;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Dto.*;
import org.b104.alfredo.user.Repository.*;
import org.b104.alfredo.user.Repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.b104.alfredo.routine.repository.RoutineRepository;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class UserService {
    @Autowired
    private RoutineRepository routineRepository;

    private final UserRepository userRepository;

    @Autowired
    private SurveyRepository surveyRepository;


    public User createUser(UserCreateDto userCreateDto) {
        User user = User.builder()
                .email(userCreateDto.getEmail())
                .uid(userCreateDto.getUid())
                .build();

        user = userRepository.save(user);

        user.setNickname("사용자" + user.getUserId());
        return userRepository.save(user);
    }

    public UserInfoDto getUserInfo(String uid) {
        User user = userRepository.findByUid(uid).orElseThrow(() -> new NoSuchElementException("User not found"));

        return new UserInfoDto(
                user.getEmail(),
                user.getNickname(),
//                user.getUid(),
                user.getBirth(),
                user.getAnswer(),
                user.getGoogleCalendarUrl()
        );
    }

    public User updateUser(String uid, UserUpdateDto userUpdateDto) {
        User user = userRepository.findByUid(uid).orElseThrow(() ->
                new NoSuchElementException("User not found with uid: " + uid));

        UserUpdateDto.updateEntity(user, userUpdateDto);
        return userRepository.save(user);
    }


    public User getUserByUid(String uid) {
        return userRepository.findByUid(uid).orElse(null);
    }

    public User updateUserToken(String uid, String token) {
        User user = userRepository.findByUid(uid).orElseThrow(() -> new NoSuchElementException("No user found with uid: " + uid));
        user.setFcmToken(token);
        System.out.println("여기 오니");
        return userRepository.saveAndFlush(user);
    }


    ////////////////////////////////// 루틴추천서비스 ///////////////////////////
    public Survey saveSurvey(String uid, SurveyDto surveyDto) {
        User user = userRepository.findByUid(uid).orElseThrow(() ->
                new NoSuchElementException("User not found with uid: " + uid));

        Survey survey = surveyDto.toEntity(user);
        return surveyRepository.save(survey);
    }



    public RecommendRoutineDto getSimilarUser(String uid) {
        User user = userRepository.findByUid(uid).orElseThrow(() -> new NoSuchElementException("User not found"));
        Survey survey = surveyRepository.findByUserUserId(user.getUserId())
                .orElseThrow(() -> new NoSuchElementException("Survey not found for user: " + uid));

        List<Integer> answers = Arrays.asList(survey.getQuestion1(), survey.getQuestion2(), survey.getQuestion3(), survey.getQuestion4(), survey.getQuestion5());

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> map = new HashMap<>();
        map.put("question1", answers.get(0));
        map.put("question2", answers.get(1));
        map.put("question3", answers.get(2));
        map.put("question4", answers.get(3));
        map.put("question5", answers.get(4));
        map.put("userId", user.getUserId());
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(map, headers);
        String url = "http://127.0.0.1:5000/recommend";

        ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);
        Long similarUserId = Long.parseLong(response.getBody());  // 문자열 응답을 Long으로 변환

        System.out.println("Similar User ID: " + similarUserId);

        List<Routine> routines = routineRepository.findByUserUserIdOrderByStartTimeAsc(similarUserId);
        List<Long> uniqueBasicRoutineIds = routines.stream()
                .filter(routine -> routine.getBasicRoutine() != null)
                .map(routine -> routine.getBasicRoutine().getId())
                .collect(Collectors.toList());

        return new RecommendRoutineDto(uniqueBasicRoutineIds);
    }


}