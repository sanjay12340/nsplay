import 'package:flutter/material.dart';

class WalletDeductionRulesWidget extends StatelessWidget {
  const WalletDeductionRulesWidget({
    super.key,
    required this.balance,
    required this.total,
    required this.money,
  });

  final String balance;
  final int total;
  final double money;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          columnWidths: {
            0: FlexColumnWidth(5),
            1: FlexColumnWidth(3),
          },
          children: [
            TableRow(children: [
              Text("Now Wallet Balance is :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("$balance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            TableRow(children: [
              Text("Total Bet Amount is: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("- $total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            TableRow(children: [
              Text("After Bet Balance is :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("${(money - total).round()}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ],
        ),
        Text(
          "After Submit your Bet it will not cancel",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
        ),
      ],
    );
  }
}
