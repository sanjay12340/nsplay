// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:nsplay/models/bet_number_modal.dart';
import 'package:nsplay/models/game_play_condition_model.dart';
import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/my_box_modal.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/play_bet_service.dart';
import 'package:nsplay/utils/game_type_card.dart';
import 'package:nsplay/utils/mycontant.dart';

import '../mywidgets/app_bar_title_widget.dart';
import '../mywidgets/balance_show_widget.dart';
import '../mywidgets/show_expended.dart';
import '../mywidgets/walet_deduction_widget.dart';
import '../services/genral_api_call.dart';
import '../utils/storage_constant.dart';

class QuickCross extends StatefulWidget {
  final GameResultModel? gameResultModel;

  const QuickCross({Key? key, @required this.gameResultModel})
      : super(key: key);

  @override
  _QuickCrossState createState() => _QuickCrossState();
}

class _QuickCrossState extends State<QuickCross> {
  var balance = "0".obs;
  final box = GetStorage();
  final List<MyBox> n = [];

  List<BetNumberModal> _betList = List<BetNumberModal>.empty(growable: true);

  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  var isWaiting = true.obs;

  var opneClose = ["Select Market"].obs;
  var _selectedValue = "Select Market".obs;
  int minBidAmount = 10;
  String gameType = "quickcross";
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  final TextEditingController _point = TextEditingController();

  var _genNumber = List<String>.empty(growable: true);
  var _genNumberClass = List<GenratedNumber>.empty(growable: true).obs;
  List<CkeckBoxWidget> listChecks = List<CkeckBoxWidget>.empty(growable: true);
  List<String> leftList = List<String>.empty(growable: true);
  List<String> rightList = List<String>.empty(growable: true);

  @override
  void initState() {
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();

    addCkecks();
  }

  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];
      box.write("money", map["money"].toString());
    }

    gpcm =
        await rgrs!.checkPlayCondtion(int.parse(widget.gameResultModel!.id!));
    if (gpcm!.playstatus!) {
      if (gpcm!.playoc == "open") {
        opneClose.value = ["open"];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else if (gpcm!.playoc == "close") {
        opneClose.value = ["close"];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      }
    } else {
      Get.back();
    }
  }

  Future<Map<String, dynamic>> submitbet(List<BetNumberModal> myjson) async {
    Map<String, dynamic> m = await PlayBet.playBetGame(myjson);
    return m;
  }

  void addCkecks() {
    for (var i = 0; i < 10; i++) {
      listChecks.add(CkeckBoxWidget(
        number: "$i",
      ));
    }
  }

  void addGenClass(GenratedNumber genratedNumber) {
    _genNumberClass.add(genratedNumber);
  }

  var _gametype = "quickcross";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
              gameName: widget.gameResultModel!.gameName!, gametype: _gametype),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          color: myPrimaryColor.withOpacity(0.1),
          child: Column(
            children: [
              SizedBox(
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
              SizedBox(
                height: 10,
              ),
              Container(
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
                        child: Obx(
                          () => (isWaiting.value)
                              ? Container(
                                  height: 40,
                                )
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    border: Border.all(
                                        color: Colors.red,
                                        style: BorderStyle.solid,
                                        width: 0.80),
                                  ),
                                  child: DropdownButton<String>(
                                    dropdownColor: Colors.white,
                                    onChanged: (value) {
                                      _selectedValue.value = value!;
                                    },
                                    value: _selectedValue.value,
                                    items: opneClose.map((val) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          "$val".toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        value: "$val",
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                        children: List.generate(
                            listChecks.length, (index) => listChecks[index])),
                  ),
                ),
              ),
              Container(
                height: 60,
                color: myWhite,
                width: Get.size.width,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        cursorColor: myBlack,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            focusColor: myAccentColor,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: myAccentColor,
                              ),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Point",
                            labelText: "Point",
                            labelStyle: TextStyle(color: myBlack)),
                        controller: _point,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Filed not Empity";
                          } else if (val.length < 2) {
                            return "Point Should be Greater then 1";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Genrate"),
                        onPressed: () {
                          leftList.clear();
                          rightList.clear();
                          _genNumber.clear();
                          _genNumberClass.clear();
                          // if (_point.text == "") {
                          //   _point.text = minBidAmount.toString();
                          // } else if (_point.text.length < 0) {
                          //   _point.text = minBidAmount.toString();
                          // }
                          // if (int.parse(_point.text) < 10) {
                          //   _point.text = minBidAmount.toString();
                          // }

                          for (var i = 0; i < listChecks.length; i++) {
                            if (listChecks[i].leftCheck.value) {
                              leftList.add(listChecks[i].number!);
                            }
                            if (listChecks[i].rightCheck.value) {
                              rightList.add(listChecks[i].number!);
                            }
                          }
                          if (leftList.length > 0 && rightList.length > 0) {
                            int pointvalue = 0;
                            try {
                              pointvalue = int.parse(_point.text);
                            } catch (e) {}
                            // both Are Correct
                            if (pointvalue >= 10) {
                              int mypoint = int.parse(_point.text);
                              for (var i = 0; i < leftList.length; i++) {
                                for (var j = 0; j < rightList.length; j++) {
                                  _genNumber
                                      .add("${leftList[i]}${rightList[j]}");

                                  addGenClass(GenratedNumber(
                                    number: "${leftList[i]}${rightList[j]}",
                                    point: mypoint,
                                  ));
                                }
                              }

                              print(_genNumber);
                              Get.bottomSheet(Container(
                                height: Get.size.height,
                                width: Get.width,
                                decoration: BoxDecoration(color: myWhite),
                                child: Obx(
                                  () => Column(
                                    children: [
                                      Container(
                                        width: Get.size.width,
                                        height: 40,
                                        decoration:
                                            BoxDecoration(color: myBlack),
                                        child: Row(
                                          children: [
                                            headingMethod("Quick Cross"),
                                            headingMethod("Point"),
                                            headingMethod("Delete"),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                        child: Column(
                                            children: List.generate(
                                                _genNumberClass.length,
                                                (index) {
                                          return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                bottom: BorderSide(
                                                  //                   <--- left side
                                                  color: Colors.black,
                                                  width: 1.0,
                                                ),
                                              )),
                                              child: Row(children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: _genNumberClass[index],
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        _genNumberClass
                                                            .removeAt(index);
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons.delete)),
                                                ),
                                              ]));
                                        })),
                                      )),
                                      Container(
                                        height: 50,
                                        width: Get.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: myWhite),
                                                  ),
                                                )),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 0,
                                                horizontal: 10,
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  _betList.clear();
                                                  Get.back();
                                                  int total = 0;
                                                  _genNumberClass.forEach((i) {
                                                    if (i.pointController!.text
                                                                .toString() !=
                                                            "" &&
                                                        int.parse(i
                                                                .pointController!
                                                                .text) >
                                                            9) {
                                                      if (int.parse(i
                                                              .pointController!
                                                              .text
                                                              .toString()) >
                                                          0) {
                                                        total += int.parse(i
                                                            .pointController!
                                                            .text
                                                            .toString());
                                                        _betList
                                                            .add(BetNumberModal(
                                                          gameid: int.parse(widget
                                                              .gameResultModel!
                                                              .id!),
                                                          openclose: "open",
                                                          date:
                                                              "${d.year}-${d.month}-${d.day}",
                                                          gametype: "jodi",
                                                          gametypefull:
                                                              "Quick Cross",
                                                          number: i.number
                                                              .toString(),
                                                          price: int.parse(i
                                                              .pointController!
                                                              .text
                                                              .toString()),
                                                          userid: int.parse(
                                                              box.read("id")),
                                                        ));
                                                      }
                                                    }
                                                  });

                                                  if (total <=
                                                      int.parse(
                                                          balance.value)) {
                                                    if (total > 0) {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            Dialog(
                                                          insetPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          child: Container(
                                                            color: Colors
                                                                .grey.shade200,
                                                            height: Get.height -
                                                                Get.height *
                                                                    0.09,
                                                            width:
                                                                Get.width - 10,
                                                            child: Column(
                                                                children: [
                                                                  Container(
                                                                    color:
                                                                        myPrimaryColor,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10),
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${widget.gameResultModel!.gameName!} - ${d.day}/${d.month}/${d.year}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                myWhite,
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: double
                                                                            .infinity -
                                                                        10,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          ExpendedCenterText(
                                                                              text: "Digit"),
                                                                          ExpendedCenterText(
                                                                              text: "Points"),
                                                                          ExpendedCenterText(
                                                                              text: "Type"),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        children: _betList
                                                                            .map(
                                                                              (e) => ShowGamePlayText(digit: e.number!, point: e.price.toString(), type: e.openclose),
                                                                            )
                                                                            .toList(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(
                                                                                flex: 1,
                                                                                child: Text("Total Bids"),
                                                                              ),
                                                                              Expanded(
                                                                                  flex: 1,
                                                                                  child: Text(
                                                                                    _betList.length.toString(),
                                                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(
                                                                                flex: 1,
                                                                                child: Text("Total Bid\nAmount"),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text(
                                                                                  total.toString(),
                                                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Divider(),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(
                                                                                flex: 1,
                                                                                child: Text("Wallet\nBalance\nBefore\nDeduction"),
                                                                              ),
                                                                              Expanded(flex: 1, child: Text(box.read(StorageConstant.money), style: const TextStyle(fontWeight: FontWeight.bold))),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              const Expanded(
                                                                                flex: 1,
                                                                                child: Text("Wallet\nBalance\nAter\nDeduction"),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Text((int.parse(box.read(StorageConstant.money)) - total).toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red)),
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    margin: EdgeInsets.only(
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text("Cancel")),
                                                                        ElevatedButton(
                                                                            onPressed:
                                                                                () async {
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
                                                                                      Expanded(child: Text("please Wait Bet is Processing"))
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                              Map m = await submitbet(_betList);
                                                                              if (m["status"]) {
                                                                                Get.back();

                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return Dialog(
                                                                                        child: Container(
                                                                                          width: Get.width - 30,
                                                                                          decoration: BoxDecoration(color: myWhite, borderRadius: BorderRadius.circular(8)),
                                                                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
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
                                                                                                style: TextStyle(color: Colors.green),
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 35,
                                                                                                width: 250,
                                                                                                child: ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      Get.back();
                                                                                                    }

                                                                                                    box.write("money", (int.parse(balance.value) - total).toString());
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.pop(context);
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

                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return Dialog(
                                                                                        child: Container(
                                                                                          width: Get.width - 30,
                                                                                          decoration: BoxDecoration(color: myWhite, borderRadius: BorderRadius.circular(8)),
                                                                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              Lottie.asset(
                                                                                                'assets/json/failed.json',
                                                                                                width: 100,
                                                                                                height: 100,
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              const Text(
                                                                                                "Your Bids Placed Failed",
                                                                                                style: TextStyle(color: Colors.red),
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                height: 10,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 35,
                                                                                                width: 250,
                                                                                                child: ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      Get.back();
                                                                                                    }

                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      Get.back();
                                                                                                    }

                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      Get.back();
                                                                                                    }

                                                                                                    if (Get.isDialogOpen!) {
                                                                                                      Get.back();
                                                                                                    }
                                                                                                    Get.back();
                                                                                                    Get.back();
                                                                                                  },
                                                                                                  child: Text("Ok"),
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    });
                                                                              }
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(primary: Colors.green),
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
                                                          middleText: (total >
                                                                  0)
                                                              ? "Select Bazar"
                                                              : (int.parse(balance
                                                                          .value) <
                                                                      1)
                                                                  ? "You dont have enough point to play please Recharge"
                                                                  : "Please select at least one number min 1 point");
                                                    }
                                                  } else {
                                                    Get.defaultDialog(
                                                        title: "Alert",
                                                        middleText:
                                                            "Insuficiant Fund");
                                                  }
                                                },
                                                child: Text("Submit",
                                                    style: TextStyle(
                                                        color: myWhite)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText: "Minimum point should be 10");
                            }
                            // both Are Correct
                          } else {
                            if (leftList.length == 0 && rightList.length == 0) {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText:
                                      "Please Select atleat on box on both side");
                            } else if (leftList.length == 0) {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText:
                                      "Please Select atleat on box on Left side");
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText:
                                      "Please Select atleat on box on Right side");
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Expanded headingMethod(String name) {
    return Expanded(
        child: Center(child: Text("$name", style: TextStyle(color: myWhite))));
  }
}

class CkeckBoxWidget extends StatelessWidget {
  final String? number;
  CkeckBoxWidget({
    required this.number,
    Key? key,
  }) : super(key: key);
  final leftCheck = false.obs;
  final rightCheck = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Expanded(
          child: Obx(
            () => Container(
              color: myWhite,
              height: 40,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("$number"),
                Checkbox(
                    value: leftCheck.value,
                    onChanged: (value) {
                      leftCheck.value = value!;
                    })
              ]),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Obx(
            () => Container(
              color: myWhite,
              height: 40,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("$number"),
                Checkbox(
                    value: rightCheck.value,
                    onChanged: (value) {
                      rightCheck.value = value!;
                    })
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class GenratedNumber extends StatelessWidget {
  final String? number;
  final int? point;
  final TextEditingController? pointController = TextEditingController();

  GenratedNumber({
    Key? key,
    required this.number,
    this.point = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    pointController!.text = "${point!}";
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(number!.toString()),
            ),
          ),
          Expanded(
            child: Container(
                child: TextFormField(
              cursorColor: myBlack,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  focusColor: myAccentColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: myAccentColor,
                    ),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(7),
                    borderSide: new BorderSide(),
                  ),
                  hintText: "Point",
                  labelStyle: TextStyle(color: myBlack)),
              controller: pointController!,
            )),
          ),
        ],
      ),
    );
  }
}
