import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/mycontant.dart';

class TextFieldNumberOnly extends StatelessWidget {
  const TextFieldNumberOnly(
      {Key? key, required this.pointController, this.hintText})
      : super(key: key);

  final TextEditingController? pointController;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: myBlack,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          focusColor: myAccentColor,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: myAccentColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(),
          ),
          hintText: hintText ?? "",
          labelStyle: TextStyle(color: myBlack)),
      controller: pointController!,
    );
  }
}
