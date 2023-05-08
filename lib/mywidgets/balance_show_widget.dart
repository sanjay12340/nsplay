import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/mycontant.dart';

class BalanceShowWidget extends StatelessWidget {
  const BalanceShowWidget({
    super.key,
    required this.balance,
  });

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/coin2.png",
          scale: 4,
        ),
        Text(
          "Balance : ",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: myWhite),
        ),
        Text(
          "$balance",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: myWhite),
        ),
      ],
    );
  }
}
