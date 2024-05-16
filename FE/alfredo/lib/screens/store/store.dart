import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<bool> purchasedItems = [false, false, false, false];
  int coinCount = 100;

  void _purchaseItem(int index) {
    setState(() {
      purchasedItems[index] = true;
      coinCount -= 10; // Each item costs 10 coins
    });
  }

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
                    _buildShopItem(0),
                    const SizedBox(width: 20),
                    _buildShopItem(1),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShopItem(2),
                    const SizedBox(width: 20),
                    _buildShopItem(3),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                const Icon(Icons.monetization_on,
                    color: Colors.amber, size: 24),
                const SizedBox(width: 4),
                Text(
                  '$coinCount',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem(int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue[100],
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
            if (!purchasedItems[index])
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
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: purchasedItems[index] ? null : () => _purchaseItem(index),
          child: Text(purchasedItems[index] ? 'Purchased' : 'Purchase'),
        ),
      ],
    );
  }
}
