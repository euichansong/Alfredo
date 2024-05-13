package org.b104.alfredo.coin.controller;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
import org.b104.alfredo.coin.response.CoinDetailDto;
import org.b104.alfredo.coin.service.CoinService;
import org.b104.alfredo.user.Domain.User;
import org.b104.alfredo.user.Service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/coin")
public class CoinController {
    private final UserService userService;
    private final CoinService coinService;

    // 조회
    @GetMapping("/detail")
    public ResponseEntity<CoinDetailDto> findCoinDetail(@RequestHeader(value = "Authorization") String authHeader) {
        try {
            String idToken = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            User user = userService.getUserByUid(uid);
            CoinDetailDto coinDetail = coinService.detailCoin(user);

            return new ResponseEntity<>(coinDetail, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error fetching achieve details", e);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}
