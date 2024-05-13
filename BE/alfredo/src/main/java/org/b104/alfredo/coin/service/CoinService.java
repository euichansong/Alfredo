package org.b104.alfredo.coin.service;


import lombok.RequiredArgsConstructor;
import org.b104.alfredo.achieve.domain.Achieve;
import org.b104.alfredo.achieve.response.AchieveDetailDto;
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

    @Transactional
    public CoinDetailDto detailCoin(User user) {
        Coin coin = coinRepository.findByUserId(user);
        if (coin == null) {
            throw new IllegalArgumentException("Achieve not found for the user");
        }
        return new CoinDetailDto(coin);
    }

}
