import 'package:flutter/material.dart';

class GameName extends StatelessWidget {
  final String gamename;
  const GameName({Key? key, required this.gamename}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 8,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text("$gamename",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
