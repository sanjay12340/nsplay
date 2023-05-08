import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  HowToPlayPage({Key? key}) : super(key: key);

  @override
  _HowToPlayPageState createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How To Play"),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            color: Colors.grey.shade900,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rules",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  Text(
                    "1. Pick a write number",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "2. Press Play button it will move to next screen",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "3. Now Pick which Type game you  Play Like Single Ank , Jodi, Single Pana, Double Pana,Triple Pana,Half Sangam, Full Sangam ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "4. Each Single Ank , Jodi, Single Pana, Double Pana,Triple Pana,Half Sangam, Full Sangam have diffrent value of winning",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "5. Enter your Amount",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "6.Submit Your bet and bet will submit on server ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "7.After Desclosing number if you are win amount will add in your account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "Note:-",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    "This game is risk involve money risk, so play with coustion",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
