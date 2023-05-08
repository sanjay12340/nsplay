import 'dart:convert';

import 'dart:math';
import 'dart:developer' as dev;

import 'package:nsplay/models/Game_result_model_total_starline.dart';
import 'package:nsplay/models/last_result.dart';

import 'package:connectivity/connectivity.dart';
import 'package:nsplay/controllers/game_result_controller.dart';
import 'package:nsplay/pages/bid_history_page_starline.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:nsplay/utils/storage_constant.dart';

import 'package:flutter/material.dart';
import 'package:nsplay/utils/links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/starline_game_type.dart';
import 'game_type_select_starline.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:intl/intl.dart';

class HomePageStarline extends StatefulWidget {
  final String? gameId;
  final String? gameName;
  final List<StarlineGameType>? starlineGameType;
  const HomePageStarline(
      {Key? key,
      required this.gameId,
      required this.starlineGameType,
      this.gameName})
      : super(key: key);

  @override
  _HomePageStarlineState createState() => _HomePageStarlineState();
}

class _HomePageStarlineState extends State<HomePageStarline> {
  GameResultController? gameResultController;
  final double timeText = 14;
  final double tabsSize = 18;
  final double tabsSizeFont = 11;
  final lastResult = LastResult(name: "", result: "--", time: "--:--").obs;
  var lname = "".obs;
  var lresult = "".obs;
  var ltime = "".obs;

  var _con = true.obs;
  var _notice = true.obs;
  var _marquee = "".obs;
  // var _phone = "";
  var _whatsapp = "";
  var _pnotice = "".obs;
  var paymentMode = "";
  Connectivity? connectvity;
  GlobalKey<RefreshIndicatorState> _refeshIndiacator = GlobalKey();
  Future<GameResultModelTotalStarline?>? gameResultData;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var box = GetStorage();
  List<String>? lis;
  GenralApiCallService? genralApiCallService;

  // var balance = 0.obs;

  @override
  void initState() {
    super.initState();

    genralApiCallService = GenralApiCallService();
    gameResultController = GameResultController();
    connectvity = Connectivity();

    connectvity!.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _con.value = true;
      } else {
        _con.value = false;
      }
    });

    gameResultData = getResultsWithTime(gameId: widget.gameId!);

    //get Notice
  }

  int randomNumber() {
    var rng = new Random();
    int rand = rng.nextInt(20000) + 3000;
    return rand;
  }

  Future<GameResultModelTotalStarline?> getResultsWithTime(
      {required String gameId}) async {
    var gameResultModelTotalStarline =
        await GameResultService.fetchGameResultWithTimeStarLine(gameId: gameId);

    // print(gameResultModelTotalStarline.toJson());

    return gameResultModelTotalStarline;
  }

  GameResultService rgrs = GameResultService();
  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs.checkBalance();
    if (map["status"]) {
      box.write("money", map["money"].toString());
      setState(() {});
      // balance.value = int.parse(box.read("money"));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          "${widget.gameName}".toUpperCase(),
        ),
        actions: [
          Row(
            children: [
              Icon(Icons.wallet),
              Text(box.read(StorageConstant.money)),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refeshIndiacator,
        onRefresh: () {
          gameResultData = getResultsWithTime(gameId: widget.gameId!);
          getBalance();
          setState(() {});
          return Future.value(false);
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Main notice board
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rates",
                          style: TextStyle(
                            color: myPrimaryColor,
                            fontSize: 18,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(BidHistoryStarline());
                          },
                          child: Text(
                            "Bid History",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  widget.starlineGameType!.length >= 4
                      ? Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5, left: 10, right: 10),
                          child: Card(
                            elevation: 8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "single Digit : 10 KA ${(double.parse(widget.starlineGameType![0].price!) * 10).round()}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "single Pana : 10 KA ${(double.parse(widget.starlineGameType![1].price!) * 10).round()}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Double Pana : 10 KA ${(double.parse(widget.starlineGameType![2].price!) * 10).round()}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Triple Pana : 10 KA ${(double.parse(widget.starlineGameType![3].price!) * 10).round()}",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),

                  Obx(() => (_con.value)
                      ? FutureBuilder(
                          future: gameResultData,
                          builder: (context,
                              AsyncSnapshot<GameResultModelTotalStarline?>
                                  snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                {
                                  return Container(
                                    child: Text("No Internet Connection"),
                                  );
                                }

                              case ConnectionState.waiting:
                                {
                                  return CircularProgressIndicator(
                                    color: myPrimaryColor,
                                  );
                                }

                              default:
                                {
                                  print("DEfault");
                                }
                                break;
                            }
                            dev.log(snapshot.data.toString(),
                                name: "GAME Data");
                            if (snapshot.data != null) {
                              GameResultModelTotalStarline? game =
                                  snapshot.data;
                              List<GameResultModelStarline?>? l =
                                  game!.gameResultModelStarline;

                              final d = game.dateTime;
                              String month = (d.month < 10)
                                  ? "0" + d.month.toString()
                                  : d.month.toString();
                              String day = (d.day < 10)
                                  ? "0" + d.day.toString()
                                  : d.day.toString();
                              String cday =
                                  (d.weekday == 7) ? "0" : d.weekday.toString();
                              String year = "${d.year}-$month-$day";

                              return Wrap(
                                children: l.map((val) {
                                  print(val?.closeTime);
                                  print("$year ${val!.closeTime}");
                                  var d2 =
                                      DateTime.parse("$year ${val.closeTime}");

                                  var diff = d2.difference(d);

                                  int td = diff.inMinutes;
                                  String playText = "";
                                  bool playCond = true;
                                  String openClose = "";

                                  if (td > 1 &&
                                      val.days!.contains("$cday") &&
                                      val.gameOnOff == "yes") {
                                    playText = "Market is Open";
                                  } else {
                                    playText = "Market is Closed";
                                    playCond = false;
                                  }
                                  return Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: Get.width * 0.442,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: myWhite,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              playText,
                                              style: TextStyle(
                                                color: (playCond)
                                                    ? Colors.green
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  color: myPrimaryColor,
                                                  size: 70,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${val.ct}",
                                                      style: TextStyle(
                                                          fontSize: timeText,
                                                          color: myPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      val.result!,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: myPrimaryColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        (playCond)
                                            ? TextButton(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: myPrimaryColorDark,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.play_arrow,
                                                        color: myWhite,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Play ",
                                                        style: TextStyle(
                                                            color: myWhite,
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GameTypeSelectStarline(
                                                          gameResultModelStarline:
                                                              val,
                                                        ),
                                                      ));
                                                },
                                              )
                                            : TextButton(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.close_rounded,
                                                        color: myWhite,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Closed ",
                                                        style: TextStyle(
                                                            color: myWhite,
                                                            fontSize: 17),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        true, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text(
                                                                  DateFormat.jm().format(DateFormat(
                                                                          "HH:mm:ss")
                                                                      .parse(val
                                                                          .time!)),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          myPrimaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18)),
                                                              Text(
                                                                  'Closed for today',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          myPrimaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16)),
                                                              TextButton(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          30),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          myPrimaryColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  child: Text(
                                                                      'OK',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              myWhite)),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              // Time Row
                                                              // End Time row
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                        // Time Row
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        // End Time row
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )
                      : const Text("No Internet Connection")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowResultBox extends StatelessWidget {
  final String? result;
  final String type;
  final Color? bgColor;
  const ShowResultBox({
    Key? key,
    required this.result,
    required this.type,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Column(
          children: [
            Text(
              result ?? 'XX',
              style: TextStyle(
                color: myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                color: myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomBtn extends StatelessWidget {
  const BottomBtn({
    Key? key,
    required this.tabsSize,
    required this.tabsSizeFont,
    this.function,
    this.icon,
    this.color,
  }) : super(key: key);
  final IconData? icon;
  final double tabsSize;
  final double tabsSizeFont;
  final VoidCallback? function;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: myWhite),
        ],
      ),
    );
  }
}

class AddWidthDraw extends StatelessWidget {
  final String? name;
  final String? fullName;
  final VoidCallback? navigation;
  final Color? bgColors;
  const AddWidthDraw(
      {Key? key,
      this.name,
      this.fullName,
      this.navigation,
      this.bgColors = Colors.blueAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: navigation,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: bgColors, borderRadius: BorderRadius.circular(8)),
            child: Text(
              fullName!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ));
  }
}

class CustomeListMenuItem extends StatelessWidget {
  CustomeListMenuItem({
    Key? key,
    required this.name,
    required this.leadingIcon,
    required this.onTap,
  }) : super(key: key);
  final double size = 22;
  final String? name;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: myPrimaryColor,
        elevation: 8,
      ),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  leadingIcon,
                  size: size,
                  color: myWhite,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  name!,
                  style: TextStyle(color: myWhite, fontSize: 16),
                )
              ],
            ),
            Icon(
              Icons.chevron_right_outlined,
              size: size,
              color: myWhite,
            )
          ],
        ),
      ),
    );
  }
}
