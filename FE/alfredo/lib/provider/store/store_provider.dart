import 'package:flutter_riverpod/flutter_riverpod.dart';

class Background extends StateNotifier<String> {
  Background(super.background);

  void update(String background) {
    state = background; // state의 타입은 StateNotifier의 제네릭 타입이다.
    // super 의 파라미터 자리의 데이터를 바꿀 수 있다.
    // 제네릭에 User 클래스 만들어 넣었다면 state.name 처럼 접근가능함
  }
}

final backgroundProvider = StateNotifierProvider<Background, String>((ref) {
  return Background('assets/mainback1.png');
});

class Character extends StateNotifier<String> {
  Character(super.character);

  void update(String character) {
    state = character; // state의 타입은 StateNotifier의 제네릭 타입이다.
    // super 의 파라미터 자리의 데이터를 바꿀 수 있다.
    // 제네릭에 User 클래스 만들어 넣었다면 state.name 처럼 접근가능함
  }
}

final characterProvider = StateNotifierProvider<Character, String>((ref) {
  return Character('assets/alfre.png');
});
