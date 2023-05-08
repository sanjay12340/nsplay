// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:lottie/lottie.dart';
import 'package:nsplay/models/bet_number_half_full_modal.dart';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/half_sangam_opne_bet_model.dart';

import 'package:nsplay/services/play_bet_service.dart';
import 'package:nsplay/utils/game_type_card.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsplay/utils/pana_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../mywidgets/auto_suggest.dart';
import '../mywidgets/show_expended.dart';
import '../mywidgets/walet_deduction_widget.dart';
import '../utils/storage_constant.dart';

class HalfSangamClose extends StatefulWidget {
  final GameResultModel? gameResultModel;
  final String? balance;
  HalfSangamClose({Key? key, required this.gameResultModel, this.balance})
      : super(key: key);

  @override
  _HalfSangamCloseState createState() => _HalfSangamCloseState();
}

class _HalfSangamCloseState extends State<HalfSangamClose> {
  var _sugessionText = TextEditingController();
  var _suggestionKey = GlobalKey<AutoCompleteTextFieldState>();
  var _ank = TextEditingController();
  var _amount = TextEditingController();
  final box = GetStorage();

  final String _selectedValue = "open";

  var _betListModel = List<HalfSangamOpenBetModel>.empty(growable: true).obs;
  List<BetNumberHalfFullModal> _betList =
      List<BetNumberHalfFullModal>.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  void add(HalfSangamOpenBetModel halfSangamOpenBetModel) {
    _betListModel.add(halfSangamOpenBetModel);
  }

  Future<Map<String?, dynamic>?> submitbet(
      List<BetNumberHalfFullModal> myjson) async {
    Map<String?, dynamic>? m = await PlayBet.playBetGameHalfFull(myjson);
    return m;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: myPrimaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            width: Get.width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: myPrimaryColor, borderRadius: BorderRadius.circular(7)),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Balance : ${widget.balance}",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: myWhite),
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
                      child: TextFormField(
                        controller: _ank,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(bottom: 0, top: 25, left: 10),
                            isDense: true,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7),
                              borderSide: new BorderSide(),
                            ),
                            hintText: "Ank",
                            labelText: "Ank"),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Filed not Empity";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EasyAutocomplete(
                        maxLength: 3,
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
                            counterText: "",
                            contentPadding:
                                EdgeInsets.only(bottom: 0, top: 25, left: 10),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(color: myPrimaryColor),
                      child: TextButton(
                          onPressed: () {
                            if (_sugessionText.text.toString() != "" &&
                                _ank.text.toString() != "" &&
                                _amount.text.toString() != "") {
                              if (panaList.contains(
                                      _sugessionText.text.toString()) &&
                                  int.parse(_ank.text.toString()) > -1 &&
                                  int.parse(_ank.text.toString()) < 10 &&
                                  int.parse(_amount.text.toString()) > 9) {
                                add(HalfSangamOpenBetModel(
                                    pana: _sugessionText.text.toString(),
                                    ank: _ank.text.toString(),
                                    amount: _amount.text.toString()));
                                _sugessionText.text = "";
                                _ank.text = "";
                                _amount.text = "";
                              } else {
                                if (!panaList.contains(_sugessionText.text))
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText: "Please Provide Valid Pana");
                                else if (!(int.parse(_ank.text) > -1 &&
                                    int.parse(_ank.text) < 10))
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText:
                                          "Please Provide Valid Ank between 0 to 9");
                                else if (!(int.parse(_amount.text.toString()) >
                                    9))
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText: "Min point should be 10");
                              }
                            } else {
                              Get.defaultDialog(
                                  title: "Alert",
                                  middleText:
                                      "Please Provide Pana , Ank and Amount all Three");
                            }
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(color: myWhite),
                          )),
                    ),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Open Ank",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Close Pana",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Amount",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Del",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
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
            decoration: BoxDecoration(color: myPrimaryColor),
            child: TextButton(
              child: Text(
                "Submit",
                style: TextStyle(color: myWhite),
              ),
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
                    gametype: "HalfSangam",
                    gametypefull: "Half Sangam",
                    openclose: _selectedValue,
                    fn: "",
                    fno: i.ank,
                    snc: "",
                    sn: i.pana,
                    date: "${d.year}-${d.month}-${d.day}",
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
                      insetPadding: const EdgeInsets.symmetric(horizontal: 2),
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
                                style: TextStyle(color: myWhite, fontSize: 20),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity - 10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
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
                                        digit: "${e.fno}-${e.sn}",
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
                                          flex: 1, child: Text("Total Bids")),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            _betList.length.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                              box.read(StorageConstant.money),
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
                                            (int.parse(box.read(StorageConstant
                                                        .money)) -
                                                    total)
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Container(
                                                  width: Get.width - 30,
                                                  decoration: BoxDecoration(
                                                      color: myWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
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
                                                            color:
                                                                Colors.green),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                        width: 250,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            if (Get
                                                                .isDialogOpen!) {
                                                              Get.back();
                                                            }

                                                            box.write(
                                                                "money",
                                                                (int.parse(widget
                                                                            .balance!) -
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
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                child: Container(
                                                  width: Get.width - 30,
                                                  decoration: BoxDecoration(
                                                      color: myWhite,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
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
                                                            color: Colors.red),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      SizedBox(
                                                        height: 35,
                                                        width: 250,
                                                        child: ElevatedButton(
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
    );
  }

  void removeAt(int index) {
    _betListModel.removeAt(index);
  }
}
