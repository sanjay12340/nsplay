import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/casino.jpeg"),
              fit: BoxFit.cover)),
    );
  }
}
