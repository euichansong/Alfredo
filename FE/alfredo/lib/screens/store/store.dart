import 'package:alfredo/provider/coin/coin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShopItem(0, 'background'),
                    const SizedBox(width: 20),
                    _buildShopItem(1, 'background'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShopItem(0, 'character'),
                    const SizedBox(width: 20),
                    _buildShopItem(1, 'character'),
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
                      return Row(
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

  Widget _buildShopItem(int index, String type) {
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
                    ? Colors.green[100]
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/mainback1.png'),
                  fit: BoxFit.cover,
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
          child: Text(items[index] ? '선택' : '\$1 구매'),
        ),
      ],
    );
  }
}
