import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nsplay/controllers/game_result_controller.dart';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/game_result_model_total.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:nsplay/utils/links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';

import 'package:url_launcher/url_launcher.dart';

import '../models/game_last_two_result_model.dart';
import 'Login.dart';

class ShayariPage extends StatefulWidget {
  ShayariPage({Key? key}) : super(key: key);

  @override
  _ShayariPageState createState() => _ShayariPageState();
}

class _ShayariPageState extends State<ShayariPage> {
  GameResultController? gameResultController;
  final double timeText = 14;
  final double tabsSize = 18;
  final double tabsSizeFont = 11;

  var _con = true.obs;

  var _marquee = "".obs;

  var _pnotice = "".obs;
  Connectivity? connectvity;
  GlobalKey<RefreshIndicatorState> _refeshIndiacator = GlobalKey();
  Future<GameResultModelTotal?>? gameResultData;
  Future<List<GameLastTwoResultModel>?>? gameLastTwoResultModel;

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

    gameResultData = getResultsWithTime();
    gameLastTwoResultModel = gameLastTwoResultModelf();
    //get Notice
    getNotice();

    getNumberOffNotifiaction();
  }

  Future<GameResultModelTotal?> getResultsWithTime() async {
    return await GameResultService.fetchGameResultWithTime();
  }

  Future<List<GameLastTwoResultModel>?> gameLastTwoResultModelf() async {
    return await GameResultService.fetchGameLastTwoResult();
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

  // isLogedIn id pnotice money username
  getNumberOffNotifiaction() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `pnotice` FROM `user` WHERE user_id = ${box.read('id')}")
        .then((value) {
      var data = jsonDecode(value);
      String str = data[0]['pnotice'];
      lis = str.split("--");
      int count = lis!.length;
      if (count > 9) {
        _pnotice.value = "+9";
      } else {
        _pnotice.value = count.toString();
      }
    });
  }

  getNotice() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `notice_id`, `notice`, `notice_date` FROM `notice` WHERE `notice_id`=2")
        .then((value) {
      var data = jsonDecode(value);
      _marquee.value = data[0]['notice'];
    });
  }

  void _launchPlayStore(String link) async {
    await canLaunch(link) ? await launch(link) : throw 'Could not launch $link';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final timer = Icon(
      Icons.timer,
      size: 16,
      color: myAccentColor,
    );

    return Scaffold(
      appBar: AppBar(title: Text(appname), actions: [
        IconButton(
            onPressed: () {
              box.write("isLogedIn", false);

              Get.offAll(() {
                return LoginPage();
              });
            },
            icon: Icon(Icons.logout))
      ]),
      body: Container(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Obx(() => (_con.value)
                    ? FutureBuilder(
                        future: gameResultData,
                        builder: (context,
                            AsyncSnapshot<GameResultModelTotal?> snapshot) {
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
                          if (snapshot.data != null) {
                            GameResultModelTotal? game = snapshot.data;
                            List<GameResultModel?>? l = game!.gameResultModel;

                            final d = game.dateTime;
                            String month = (d!.month < 10)
                                ? "0" + d.month.toString()
                                : d.month.toString();
                            String day = (d.day < 10)
                                ? "0" + d.day.toString()
                                : d.day.toString();
                            String cday =
                                (d.weekday == 7) ? "0" : d.weekday.toString();
                            String year = "${d.year}-$month-$day";

                            return Column(
                              children: l!.map((val) {
                                var d2 =
                                    DateTime.parse("$year ${val!.closeTime}");
                                var d3 =
                                    DateTime.parse("$year ${val.openTime}");
                                var diff = d2.difference(d);
                                var diff3 = d3.difference(d);
                                int td = diff.inHours * 60 + diff.inMinutes;
                                int td2 = diff3.inHours * 60 + diff3.inMinutes;
                                //String playText = "";

                                if (td > 1 &&
                                    val.days!.contains("$cday") &&
                                    val.gameOnOff == "yes") {
                                  if (td2 > 1) {
                                    print(
                                        '''Account val.gameName openClose ${td2.toString()}  $year ${val.openTime} $d''');
                                  } else {
                                    print(
                                        '''Account 
                                        val.gameName 
                                        
                                        openClose 
                                    
                                        ${td2.toString()} 
                                        "-- $year ${val.openTime} -- $d''');
                                  }
                                  //playText = "Market is Open";
                                } else {
                                  // playText = "Market is Closed";
                                }
                                return Stack(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black,
                                              spreadRadius: 1,
                                              blurRadius: 4)
                                        ],
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.6),
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: 30, left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "${val.gameName}",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Chonburi',
                                                          color: Colors.yellow,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "${val.result}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Time Row
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Open Time
                                            Row(
                                              children: [
                                                timer,
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  "Open ${val.ot}",
                                                  style: TextStyle(
                                                      fontSize: timeText,
                                                      color: myWhite,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            // End Opne time

                                            // Close  Time
                                            Row(
                                              children: [
                                                timer,
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text(
                                                  "Close ${val.ct}",
                                                  style: TextStyle(
                                                      fontSize: timeText,
                                                      color: myWhite,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            )
                                            // End Close time
                                          ],
                                        ),
                                        // End Time row
                                      ],
                                    ),
                                  ),
                                ]);
                              }).toList(),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    : Container(
                        child: Text("No Internet Connection"),
                      )),
                SizedBox(
                  height: 60,
                )
              ],
            ),
          ),
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
          Icon(
            icon,
            size: 30,
            color: color ?? Colors.black,
          ),
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
  AddWidthDraw(
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
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: bgColors, borderRadius: BorderRadius.circular(8)),
            child: Text(
              fullName!.toUpperCase(),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          onTap: navigation,
        ));
  }
}
