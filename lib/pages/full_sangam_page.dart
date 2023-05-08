// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:lottie/lottie.dart';
import 'package:nsplay/models/bet_number_half_full_modal.dart';
import 'package:nsplay/models/game_play_condition_model.dart';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/half_sangam_opne_bet_model.dart';
import 'package:nsplay/mywidgets/game_name_card.dart';
import 'package:nsplay/pages/Login.dart';
import 'package:nsplay/services/game_result_service.dart';

import 'package:nsplay/services/play_bet_service.dart';
import 'package:nsplay/utils/game_type_card.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:nsplay/utils/value_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsplay/utils/pana_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../mywidgets/auto_suggest.dart';
import '../mywidgets/show_expended.dart';
import '../mywidgets/walet_deduction_widget.dart';
import '../utils/storage_constant.dart';
import 'home_page.dart';

// import 'package:nsplay/controllers/half_sangam_open_bet_controller.dart';

class FullSangamPage extends StatefulWidget {
  final GameResultModel? gameResultModel;

  FullSangamPage({Key? key, required this.gameResultModel}) : super(key: key);

  @override
  _FullSangamPageState createState() => _FullSangamPageState();
}

class _FullSangamPageState extends State<FullSangamPage> {
  var balance = "0".obs;
  var _sugessionText = TextEditingController();
  var _sugessionPanaList = panaList;
  var _suggestionKey = GlobalKey<AutoCompleteTextFieldState>();
  var _sugessionText2 = TextEditingController();
  var _suggestionKey2 = GlobalKey<AutoCompleteTextFieldState>();
  final scrollController = ScrollController();

  var _amount = TextEditingController();
  final box = GetStorage();

  final String _selectedValue = "open";

  var _betListModel = List<HalfSangamOpenBetModel>.empty(growable: true).obs;
  List<BetNumberHalfFullModal> _betList =
      List<BetNumberHalfFullModal>.empty(growable: true);
  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  @override
  void initState() {
    super.initState();
    getBalance();
  }

  void add(HalfSangamOpenBetModel halfSangamOpenBetModel) {
    setState(() {
      _betListModel.add(halfSangamOpenBetModel);
    });
    _betListModel.forEach((element) {
      print("object");
      print(element.pana);
    });
  }

  Future<Map<String?, dynamic>?> submitbet(
      List<BetNumberHalfFullModal> myjson) async {
    Map<String?, dynamic>? m = await PlayBet.playBetGameHalfFull(myjson);
    return m;
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
      if (gpcm!.playoc != "open") {
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Alert",
            middleText: "Market is Closed",
            content: ElevatedButton(
                onPressed: () {
                  Get.offAll(() => HomePage());
                },
                child: SizedBox(width: 100, child: Text("Ok"))));
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.gameResultModel!.gameName}, FULL SANGAM",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(color: myPrimaryColor.withOpacity(0.1)),
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
                  () => Text(
                    "Balance : ${balance.value}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: myWhite),
                  ),
                ),
              ),
              Card(
                elevation: 8,
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: EasyAutocomplete(
                              controller: _sugessionText,
                              suggestionTextStyle: TextStyle(fontSize: 18),
                              suggestions: panaList,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Not valid";
                                } else if (val.length != 3) {
                                  return "Not valid";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.only(
                                      bottom: 0, top: 25, left: 10),
                                  isDense: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(7),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Pana",
                                  labelText: "Pana"),
                              onChanged: (value) {},
                              onSubmitted: (value) =>
                                  print('onSubmitted value: $value'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: EasyAutocomplete(
                              controller: _sugessionText2,
                              suggestionTextStyle: TextStyle(fontSize: 18),
                              suggestions: panaList,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Not valid";
                                } else if (val.length != 3) {
                                  return "Not valid";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: EdgeInsets.only(
                                      bottom: 0, top: 25, left: 10),
                                  isDense: true,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(7),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Pana",
                                  labelText: "Pana"),
                              onChanged: (value) {},
                              onSubmitted: (value) =>
                                  print('onSubmitted value: $value'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _amount,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 0, top: 25, left: 10),
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(7),
                                borderSide: new BorderSide(),
                              ),
                              hintText: "Amount",
                              labelText: "Amount"),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Filed not Empity";
                            } else if (int.parse(val) < 10) {
                              return "Amount should not less then 10";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {
                              print(_sugessionText.text);
                              print(_sugessionText2.text);
                              print(_amount.text);
                              if (_sugessionText.text.isNotEmpty &&
                                  _sugessionText2.text.isNotEmpty &&
                                  _amount.text.isNotEmpty) {
                                if (panaList.contains(
                                        _sugessionText.text.toString()) &&
                                    panaList.contains(
                                        _sugessionText2.text.toString()) &&
                                    int.parse(_amount.text.toString()) > 9) {
                                  add(HalfSangamOpenBetModel(
                                      pana: _sugessionText.text,
                                      ank: _sugessionText2.text,
                                      amount: _amount.text));
                                  _sugessionText.text = "";
                                  _sugessionText2.text = "";
                                  _amount.text = "";
                                } else {
                                  if (!(int.parse(_amount.text.toString()) > 9))
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText: "Min point should be 10");
                                  else if (!panaList
                                      .contains(_sugessionText.text))
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText:
                                            "Please Provide Valid Open Pana");
                                  else if (!panaList
                                      .contains(_sugessionText2.text))
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText:
                                            "Please Provide Valid Close Pana");
                                }
                              } else {
                                Get.defaultDialog(
                                    title: "Alert",
                                    middleText: "Please Provide  Amount all ");
                              }
                            },
                            child: Text("Add")),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Table(
                        columnWidths: {
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                        },
                        border: TableBorder.all(),
                        children: [
                          TableRow(
                              decoration: BoxDecoration(color: Colors.black),
                              children: [
                                Text(
                                  "Open Pana",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Close Pana",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Amount",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Del",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ]),
                        ],
                      ),
                      Obx(() => Table(
                            columnWidths: {
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(0.5),
                            },
                            border: TableBorder.all(),
                            children: List.generate(
                              _betListModel.length,
                              (index) {
                                return TableRow(children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      color: Colors.red.shade900,
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: Text(
                                        _betListModel[index].pana.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      color: Colors.green,
                                      child: Text(
                                        _betListModel[index].ank.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      color: Colors.purple,
                                      child: Text(
                                        _betListModel[index].amount.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: InkWell(
                                      splashColor: Colors.red,
                                      onTap: () {
                                        removeAt(index);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ]);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              )),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    // Submit
                    _betList.clear();
                    int total = 0;
                    _betListModel.forEach((i) {
                      total += int.parse(i.amount.toString());
                      _betList.add(BetNumberHalfFullModal(
                        userid: int.parse(box.read("id")),
                        gameid: int.parse(widget.gameResultModel!.id!),
                        bidamount: int.parse(i.amount!),
                        gametype: "FullSangam",
                        gametypefull: "Full Sanagm",
                        openclose: _selectedValue,
                        fn: i.pana,
                        fno: "",
                        snc: "",
                        sn: i.ank,
                        date: "${d.year}-${d.month}${d.day}",
                      ));
                    });

                    bool flag = true;
                    if (total > int.parse(box.read("money"))) {
                      flag = false;
                      Get.defaultDialog(
                          title: "Alert", middleText: "insuficiant Fund");
                    }
                    if (flag) {
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
                                    "${widget.gameResultModel!.gameName!} - ${d.day}/${d.month}/${d.year}",
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
                                    children: [
                                      ExpendedCenterText(text: "Digit"),
                                      ExpendedCenterText(text: "Points"),
                                      ExpendedCenterText(text: "Type"),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: _betList
                                        .map((e) => ShowGamePlayText(
                                            digit: "${e.fn!}-${e.sn}",
                                            point: e.bidamount.toString(),
                                            type: e.openclose))
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
                                          Map<String?, dynamic>? m =
                                              await submitbet(_betList);
                                          if (m!["status"]) {
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
                                                            'assets/json/failed.json',
                                                            width: 100,
                                                            height: 100,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          const Text(
                                                            "Your Bids Placed Failed",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
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

                                                                if (Get
                                                                    .isDialogOpen!) {
                                                                  Get.back();
                                                                }

                                                                if (Get
                                                                    .isDialogOpen!) {
                                                                  Get.back();
                                                                }

                                                                if (Get
                                                                    .isDialogOpen!) {
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
                    }

                    // Submit end
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void removeAt(int index) {
    _betListModel.removeAt(index);
  }
}
