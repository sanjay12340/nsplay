import 'package:nsplay/models/game_rate_model.dart';

import 'package:nsplay/services/genral_api_call.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nsplay/utils/mycontant.dart';

class GameRatePage extends StatefulWidget {
  GameRatePage({Key? key}) : super(key: key);

  @override
  _GameRatePageState createState() => _GameRatePageState();
}

class _GameRatePageState extends State<GameRatePage> {
  GenralApiCallService? genralApiCallService;
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Rate"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: genralApiCallService!.fetchGenralQueryWithRawData(
            "SELECT  `fname`, `price` FROM `game_type` ORDER BY `game_type`.`myorder` ASC"),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Text("No Internet Connection"),
                  ),
                ],
              );

            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );

            default:
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  List<GameRateModel> l =
                      gameRateModelFromJson(snapshot.data.toString());
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: l.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: myPrimaryColor,
                          ),
                          height: 60,
                          width: Get.size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Center(
                                child: Text(
                                  e.fname!,
                                  style:
                                      TextStyle(color: myWhite, fontSize: 22),
                                ),
                              )),
                              Expanded(
                                  child: Container(
                                color: myAccentColor,
                                child: Center(
                                  child: Text(
                                      "10/${(double.parse(e.price!) * 10).round()}",
                                      style: TextStyle(
                                          color: myWhite, fontSize: 22)),
                                ),
                              ))
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class TableCellResult extends StatelessWidget {
  const TableCellResult({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class TableCellResultHead extends StatelessWidget {
  const TableCellResultHead({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      color: Colors.red.shade900,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
