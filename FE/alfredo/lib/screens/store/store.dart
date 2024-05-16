import 'package:alfredo/provider/coin/coin_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alfredo/provider/store/store_provider.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  List<bool> purchasedBackground = [false, false];
  List<bool> purchasedCharacter = [false, false];
  int? selectedBackgroundIndex;
  int? selectedCharacterIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: const Color(0xFF0D2338),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/storebackground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '배경 구매',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.33,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {},
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [
                    _buildShopItem(0, 'background', 'assets/mainback1.png'),
                    _buildShopItem(1, 'background', 'assets/officemain.png'),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '캐릭터 구매',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.33,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {},
                    scrollDirection: Axis.horizontal,
                  ),
                  items: [
                    _buildShopItem(0, 'character', 'assets/alfrecopy.png'),
                    _buildShopItem(1, 'character', 'assets/catmancopy.png'),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Consumer(
              builder: (context, watch, child) {
                final coinCount = ref.watch(coinProvider);
                return coinCount.when(
                    data: (data) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.amber, size: 24),
                            const SizedBox(width: 4),
                            Text(
                              '${data.totalCoin}',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                    error: (err, stack) => Text('Error: $err'),
                    loading: () => const CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem(int index, String type, String background) {
    List<bool> items =
        type == 'background' ? purchasedBackground : purchasedCharacter;
    int? selectedIndex =
        type == 'background' ? selectedBackgroundIndex : selectedCharacterIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? const Color(0xFFE7D8BC)
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  // ignore: unnecessary_string_interpolations
                  image: AssetImage(background),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            if (!items[index])
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.lock,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            if (selectedIndex == index)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black54.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: items[index]
              ? type == 'background'
                  ? selectedBackgroundIndex == index
                      ? null
                      : () {
                          setState(() {
                            selectedBackgroundIndex = index;
                          });
                        }
                  : selectedCharacterIndex == index
                      ? null
                      : () {
                          setState(() {
                            selectedCharacterIndex = index;
                          });
                        }
              : () async {
                  var coin =
                      await ref.read(coinControllerProvider).getCoinDetail();
                  if (coin.totalCoin >= 1) {
                    // ref.read(coinControllerProvider).incrementCoin();
                    // ref.read(coinControllerProvider).decrementTotalCoin(1);
                    setState(() {
                      items[index] = true;
                      if (type == 'background') {
                        selectedBackgroundIndex = index;
                      } else {
                        selectedCharacterIndex = index;
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('코인 갯수가 적습니다.')),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: const Color(0xFFE0E0E0),
            foregroundColor: const Color(0xFF0D2338),
          ),
          child: Text(items[index] ? '선택' : '\$1 구매'),
        ),
      ],
    );
  }
}
