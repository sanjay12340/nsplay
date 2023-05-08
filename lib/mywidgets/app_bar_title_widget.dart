import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    
    required String gametype, required this.gameName,
  }) : _gametype = gametype;

  final String  gameName;
  final String _gametype;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${gameName}, ${_gametype}".toUpperCase(),
      style: TextStyle(fontSize: 15),
    );
  }
}