import 'package:flutter/material.dart';

class GameTypeCard extends StatelessWidget {
  final String? name;
  const GameTypeCard({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text(name ?? "Game",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
