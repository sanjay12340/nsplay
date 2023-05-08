import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nsplay/models/Game_result_model_total_starline.dart';
import 'package:nsplay/models/my_box_modal.dart';

import 'package:nsplay/utils/mycontant.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:nsplay/models/bet_number_modal.dart';
import 'package:nsplay/models/game_play_condition_model.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/play_bet_service.dart';

import '../models/bet_number_starline_modal.dart';
import '../mywidgets/app_bar_title_widget.dart';
import '../mywidgets/balance_show_widget.dart';
import '../mywidgets/show_expended.dart';
import '../mywidgets/walet_deduction_widget.dart';
import '../utils/storage_constant.dart';

class SingleAnkPageStarline extends StatefulWidget {
  final GameResultModelStarline? gameResultModelStarline;

  const SingleAnkPageStarline(
      {Key? key, @required this.gameResultModelStarline})
      : super(key: key);

  @override
  _SingleAnkPageStarlineState createState() => _SingleAnkPageStarlineState();
}

class _SingleAnkPageStarlineState extends State<SingleAnkPageStarline> {
  var balance = "0".obs;
  final box = GetStorage();
  final List<MyBox> n = [
    MyBox(
      number: "0",
    ),
    MyBox(
      number: "1",
    ),
    MyBox(
      number: "2",
    ),
    MyBox(
      number: "3",
    ),
    MyBox(
      number: "4",
    ),
    MyBox(
      number: "5",
    ),
    MyBox(
      number: "6",
    ),
    MyBox(
      number: "7",
    ),
    MyBox(
      number: "8",
    ),
    MyBox(
      number: "9",
    )
  ];

  final List<BetNumberStarlineModal> _betList =
      List<BetNumberStarlineModal>.empty(growable: true);

  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  var isWaiting = true.obs;

  var opneClose = ["Select Market"].obs;
  var _selectedValue = "Select Market".obs;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();
  }

  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];
      box.write("money", map["money"].toString());
    }
    GameResultService.checkPlayConditionStarline(
            time: widget.gameResultModelStarline!.closeTime!)
        .then((value) {
      if (!value!) {
        Get.back();
      }
    });
  }

  Future<Map<String, dynamic>> submitbet(
      List<BetNumberStarlineModal> myjson) async {
    Map<String, dynamic> m = await PlayBet.playBetGameStarline(myjson);
    return m;
  }

  final _gametype = "singleank";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
            gameName: widget.gameResultModelStarline!.gameName!,
            gametype: _gametype),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: myPrimaryColor.withOpacity(0.1),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width * 0.9,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: myPrimaryColor,
                  borderRadius: BorderRadius.circular(7)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Obx(
                () => BalanceShowWidget(balance: balance.value),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width * 0.9,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/calendar.png",
                            scale: 1.8,
                          ),
                          Text(
                            "${DateFormat("d MMM y").format(d)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          widget.gameResultModelStarline!.resultTime!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 4,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: n.map((val) => val).toList(),
            ),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: myPrimaryColorDark,
                ),
                onPressed: () {
                  _betList.clear();
                  int total = 0;
                  n.forEach((i) {
                    if (i.controller.text.toString() != "") {
                      if (int.parse(i.controller.text.toString()) > 9) {
                        total += int.parse(i.controller.text.toString());
                        _betList.add(BetNumberStarlineModal(
                            gameid:
                                int.parse(widget.gameResultModelStarline!.id!),
                            time: widget.gameResultModelStarline!.time!,
                            date: "${d.year}-${d.month}-${d.day}",
                            gametype: "singleank",
                            number: i.number.toString(),
                            price: int.parse(i.controller.text.toString()),
                            userid: int.parse(box.read("id")),
                            gametypefull: "Single Ank"));
                      }
                    }
                  });

                  if (total <= int.parse(balance.value)) {
                    if (total > 9) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          insetPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            color: Colors.grey.shade200,
                            height: Get.height - Get.height * 0.09,
                            width: Get.width - 10,
                            child: Column(children: [
                              Container(
                                color: myPrimaryColor,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "${widget.gameResultModelStarline!.gameName!} - ${d.day}/${d.month}/${d.year}",
                                    style:
                                        TextStyle(color: myWhite, fontSize: 20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity - 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: const [
                                      ExpendedCenterText(text: "Digit"),
                                      ExpendedCenterText(text: "Points"),
                                      ExpendedCenterText(text: "Time"),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: _betList
                                        .map((e) => ShowGamePlayText(
                                            digit: e.number!,
                                            point: e.price.toString(),
                                            type: DateFormat.jm().format(
                                                DateFormat("HH:mm:ss")
                                                    .parse(e.time!))))
                                        .toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                              flex: 1,
                                              child: Text("Total Bids")),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                _betList.length.toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                              flex: 1,
                                              child: Text("Total Bid\nAmount")),
                                          Expanded(
                                              flex: 1,
                                              child: Text(total.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                                "Wallet\nBalance\nBefore\nDeduction"),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  box.read(
                                                      StorageConstant.money),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 1,
                                            child: Text(
                                                "Wallet\nBalance\nAter\nDeduction"),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                (int.parse(box.read(
                                                            StorageConstant
                                                                .money)) -
                                                        total)
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                  "*Note: Bid once played cannot be cancelled*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel")),
                                    ElevatedButton(
                                        onPressed: () async {
                                          Get.defaultDialog(
                                            barrierDismissible: false,
                                            radius: 0,
                                            title: "Wait",
                                            content: Container(
                                              width: double.infinity,
                                              child: Row(
                                                children: const [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  CircularProgressIndicator(),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                          "please Wait Bet is Processing"))
                                                ],
                                              ),
                                            ),
                                          );
                                          Map m = await submitbet(_betList);
                                          if (m["status"]) {
                                            Get.back();

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: Container(
                                                      width: Get.width - 30,
                                                      decoration: BoxDecoration(
                                                          color: myWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 10),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Lottie.asset(
                                                            'assets/json/success.json',
                                                            width: 100,
                                                            height: 100,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Text(
                                                            "Your Bids Placed Successfully",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          SizedBox(
                                                            height: 35,
                                                            width: 250,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                if (Get
                                                                    .isDialogOpen!) {
                                                                  Get.back();
                                                                }

                                                                box.write(
                                                                    "money",
                                                                    (int.parse(balance.value) -
                                                                            total)
                                                                        .toString());
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text("Ok"),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else {
                                            Get.back();

                                            showDialog<String>(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    Dialog(
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Lottie.asset(
                                                              'assets/json/success.json',
                                                              width: 100,
                                                              height: 100,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const Text(
                                                              "Your Bids Placed Successfully",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            SizedBox(
                                                              height: 35,
                                                              width: 250,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  if (Get
                                                                      .isDialogOpen!) {
                                                                    Get.back();
                                                                  }
                                                                },
                                                                child:
                                                                    Text("Ok"),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green),
                                        child: const Text("Submit Bet")),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    } else {
                      Get.defaultDialog(
                          title: "Alert",
                          middleText: (int.parse(balance.value) < 10)
                              ? "You dont have enough point to play please Recharge"
                              : "Please select at least one number min 10 point");
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Alert", middleText: "Insuficiant Fund");
                  }
                },
                child: Container(
                  width: Get.width * 0.5,
                  alignment: Alignment.center,
                  child: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
