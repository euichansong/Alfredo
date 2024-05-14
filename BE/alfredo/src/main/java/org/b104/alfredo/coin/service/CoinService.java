package org.b104.alfredo.coin.service;


import lombok.RequiredArgsConstructor;
import org.b104.alfredo.coin.domain.Coin;
import org.b104.alfredo.coin.repository.CoinRepository;
import org.b104.alfredo.coin.response.CoinDetailDto;
import org.b104.alfredo.user.Domain.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CoinService {
    private final CoinRepository coinRepository;

    // 코인 조회
    @Transactional
    public CoinDetailDto detailCoin(User user) {
        Coin coin = coinRepository.findByUserId(user);
        if (coin == null) {
            throw new IllegalArgumentException("Achieve not found for the user");
        }
        return new CoinDetailDto(coin);
    }

    @Transactional
    public void updateTotalCoin(User user, int additionalCoins) {
        Coin coin = coinRepository.findByUserId(user);
        if (coin != null) {
            coin.updateTotalCoin(coin.getTotalCoin() + additionalCoins);
        }
    }

    // 코인 생성
    @Transactional
    public Coin createCoin(User user) {
        // 유저당 코인 기록이 이미 있는지 확인
        Coin existingCoin = coinRepository.findByUserId(user);
        if (existingCoin != null) {
            throw new IllegalArgumentException("이 유저에 대한 코인 기록이 이미 존재합니다.");
        }

        // 새로운 코인 기록 생성
        Coin newCoin = Coin.builder()
                .userId(user)
                .totalCoin(0)
                .todayCoin(0)
                .build();

        return coinRepository.save(newCoin);
    }

}
