import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfomationPage extends StatefulWidget {
  InfomationPage({Key? key}) : super(key: key);

  @override
  _InfomationPageState createState() => _InfomationPageState();
}

class _InfomationPageState extends State<InfomationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Notice Board")),
              ElevatedButton(onPressed: () {}, child: Text("How To Play")),
              ElevatedButton(onPressed: () {}, child: Text("Time Table")),
            ],
          ),
        ),
      ),
    );
  }
}
