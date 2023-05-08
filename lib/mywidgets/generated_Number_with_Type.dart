import 'package:flutter/material.dart';
import 'package:nsplay/mywidgets/text_field_number_only.dart';

class GenratedNumberWithGameType extends StatelessWidget {
  final String? number;
  final int? point;
  final String? gameType;
  final TextEditingController? pointController = TextEditingController();

  GenratedNumberWithGameType(
      {Key? key, required this.number, this.point = 10, required this.gameType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    pointController!.text = "${point!}";
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(number!.toString()),
          ),
        ),
        Expanded(
          child: TextFieldNumberOnly(
              pointController: pointController, hintText: "Point"),
        ),
      ],
    );
  }
}
