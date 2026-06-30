import 'package:flutter/material.dart';
import 'screens/market_screen.dart';

void main() {
  runApp(const MerchantCaravanApp());
}

class MerchantCaravanApp extends StatelessWidget {
  const MerchantCaravanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MarketScreen(),
    );
  }
}