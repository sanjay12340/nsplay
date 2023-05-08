import 'package:flutter/material.dart';

class ShowGamePlayText extends StatelessWidget {
  const ShowGamePlayText({
    super.key,
    required this.digit,
    required this.point,
    required this.type,
  });

  final String? digit;
  final String? point;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: SizedBox(
        width: double.infinity - 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              ExpendedCenterText(text: digit),
              ExpendedCenterText(text: point),
              ExpendedCenterText(text: type),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpendedCenterTextDigit extends StatelessWidget {
  const ExpendedCenterTextDigit({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Text(
      text!,
      style: const TextStyle(fontSize: 18),
    )));
  }
}

class ExpendedCenterText extends StatelessWidget {
  const ExpendedCenterText({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Text(
      text!,
      style: const TextStyle(fontSize: 18),
    )));
  }
}
