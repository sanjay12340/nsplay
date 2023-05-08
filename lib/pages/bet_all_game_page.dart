import 'dart:developer';

import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:date_time_format/date_time_format.dart';

import 'package:nsplay/models/game_result_model.dart';

import 'package:nsplay/services/play_bet_service.dart';
import 'package:nsplay/utils/game_type_card.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsplay/utils/pana_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';

import '../models/ank_pana_joisi_model.dart';
import '../models/bet_number_modal.dart';
import '../models/game_play_condition_model.dart';
import '../services/game_result_service.dart';
import 'package:intl/intl.dart';

// import 'package:nsplay/controllers/half_sangam_open_bet_controller.dart';

class BetAllTypePage extends StatefulWidget {
  final GameResultModel? gameResultModel;
  final String gameType;
  final String gameTypeFullName;
  final bool? isforClose;
  final List<String> numberList;
  final int textLength;
  BetAllTypePage(
      {Key? key,
      required this.gameResultModel,
      required this.gameType,
      required this.gameTypeFullName,
      required this.numberList,
      required this.textLength,
      this.isforClose})
      : super(key: key);

  @override
  _BetAllTypePageState createState() => _BetAllTypePageState();
}

class _BetAllTypePageState extends State<BetAllTypePage> {
  var _sugessionText = TextEditingController();
  var _suggestionKey = GlobalKey<AutoCompleteTextFieldState>();
  var _ank = TextEditingController();
  var _amount = TextEditingController();
  final box = GetStorage();
  var isWaiting = true.obs;
  var opneClose = ["Select Market"].obs;
  var _selectedValue = "Select Market".obs;
  var balance = "0".obs;

  var _betListModel = List<AnkJodiPanaModel>.empty(growable: true).obs;
  List<BetNumberModal> _betList = List<BetNumberModal>.empty(growable: true);
  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  @override
  void initState() {
    super.initState();

    getBalance();
  }

  getBalance() async {
    balance.value = box.read(StorageConstant.money);
    print("Calleddd");
    rgrs = GameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];

      box.write(StorageConstant.money, map["money"].toString());
    }

    gpcm =
        await rgrs!.checkPlayCondtion(int.parse(widget.gameResultModel!.id!));

    if (gpcm!.playstatus!) {
      if (gpcm!.playoc == "open_only") {
        opneClose.value = widget.isforClose! ? ["open"] : ['open'];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else if (gpcm!.playoc == "open") {
        opneClose.value = widget.isforClose! ? ["open", "close"] : ['open'];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else if (gpcm!.playoc == "close" && widget.isforClose!) {
        opneClose.value = ["close"];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else {
        Get.back();
      }
    } else {
      Get.back();
    }
  }

  void add(AnkJodiPanaModel ankJodiPanaModel) {
    _betListModel.add(ankJodiPanaModel);
  }

  Future<Map<String, dynamic>> submitbet(List<BetNumberModal> myjson) async {
    Map<String, dynamic> m = await PlayBet.playBetGame(myjson);
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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.gameResultModel!.gameName}, ${widget.gameTypeFullName}"
                .toUpperCase(),
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Column(
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
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width * 0.9,
              color: myThirdColor,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "${d.day}/${d.month}/${d.year}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16),
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
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
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
            Card(
              elevation: 8,
              shadowColor: Colors.white,
              child: Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                  ],
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
                        child: AutoCompleteTextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(widget.textLength),
                          ],
                          key: _suggestionKey,
                          clearOnSubmit: false,
                          controller: _sugessionText,
                          suggestions: widget.numberList,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 0, top: 25, left: 10),
                              isDense: true,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(7),
                                borderSide: new BorderSide(),
                              ),
                              hintText: widget.gameTypeFullName,
                              labelText: widget.gameTypeFullName),
                          itemFilter: (items, query) {
                            return items
                                .toString()
                                .startsWith(query.toString());
                          },
                          itemSorter: (a, b) {
                            return a.toString().compareTo(b.toString());
                          },
                          itemSubmitted: (item) {
                            _sugessionText.text = item.toString();
                          },
                          itemBuilder: (context, item) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Text(
                                  "$item",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
                                    _amount.text.toString() != "") {
                                  if (widget.numberList.contains(
                                          _sugessionText.text.toString()) &&
                                      int.parse(_amount.text.toString()) > 9) {
                                    add(AnkJodiPanaModel(
                                        number: _sugessionText.text,
                                        amount: _amount.text));
                                    _sugessionText.text = "";

                                    _amount.text = "";
                                  } else {
                                    if (!widget.numberList.contains(
                                        _sugessionText.text.toString()))
                                      Get.defaultDialog(
                                          title: "Alert",
                                          middleText:
                                              "Please Provide Valid ${widget.gameTypeFullName}");
                                    else if (!(int.parse(
                                            _amount.text.toString()) >
                                        9))
                                      Get.defaultDialog(
                                          title: "Alert",
                                          middleText: "Min point should be 10");
                                  }
                                } else {
                                  Get.defaultDialog(
                                      title: "Alert",
                                      middleText:
                                          "Please Provide ${widget.gameTypeFullName}");
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
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      },
                      border: TableBorder.all(color: Colors.grey),
                      children: [
                        TableRow(
                            decoration: BoxDecoration(color: Colors.black),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  widget.gameTypeFullName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "Amount",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                          border: TableBorder.all(color: Colors.grey.shade200),
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
                                    child: Text(
                                      _betListModel[index].number.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    child: Text(
                                      _betListModel[index].amount.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
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
                    _betList.add(BetNumberModal(
                      gameid: int.parse(widget.gameResultModel!.id!),
                      openclose: _selectedValue.value.toString(),
                      date: "${d.year}-${d.month}-${d.day}",
                      gametype: widget.gameType,
                      number: i.number.toString(),
                      price: int.parse(i.amount!),
                      userid: int.parse(box.read(StorageConstant.id)),
                    ));
                  });

                  bool flag = true;
                  print(
                      " my total money $total and ${box.read("money")}  pending ${int.parse(box.read("money")) - total} ");
                  if (total > int.parse(box.read("money"))) {
                    flag = false;
                    Get.defaultDialog(
                        title: "Alert", middleText: "insuficiant Fund");
                  }
                  if (flag) {
                    Get.bottomSheet(
                        Container(
                          height: size.height - 100,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          "${widget.gameResultModel!.gameName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Text(
                                        "Market : $_selectedValue",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          widget.gameTypeFullName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Text(
                                        "Date : ${d.day}-${d.month}-${d.year}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade800,
                                child: Table(
                                  children: [
                                    TableRow(children: [
                                      Center(
                                        child: Text(
                                          widget.gameTypeFullName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Center(
                                          child: Text("Amount",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ]),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: SingleChildScrollView(
                                    child: Table(
                                      border: TableBorder.all(
                                          color: Colors.grey.shade300),
                                      children: _betList
                                          .map((val) => TableRow(children: [
                                                Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "${val.number}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("${val.price}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )),
                                              ]))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 2,
                                width: double.infinity,
                                color: Colors.blue,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(5),
                                        1: FlexColumnWidth(3),
                                      },
                                      children: [
                                        TableRow(children: [
                                          Text("Total Bet Amount : ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text("$total",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                        TableRow(children: [
                                          Text("Before Bet Wallet Amount :",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "${box.read(StorageConstant.money)}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                        TableRow(children: [
                                          Text("Before Bet Wallet Amount :",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "${int.parse(box.read("money")) - total}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                      ],
                                    ),
                                    Text(
                                      "After Submit your Bet it will not cancel",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                elevation: 8,
                                child: Container(
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
                                            Get.back();
                                            Get.defaultDialog(
                                              barrierDismissible: false,
                                              radius: 0,
                                              title: "Wait",
                                              content: Container(
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
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
                                            if (m["status"]) {
                                              Get.back();
                                              Get.defaultDialog(
                                                barrierDismissible: false,
                                                content: Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          "Bet is Successfull"),
                                                      SizedBox(
                                                        height: 35,
                                                        width: 250,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            box.write(
                                                                "money",
                                                                (int.parse(box.read(
                                                                            "money")) -
                                                                        total)
                                                                    .toString());
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
                                            } else {
                                              Get.back();
                                              Get.defaultDialog(
                                                content: Container(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                          "Bet is Failed Try Again"),
                                                      SizedBox(
                                                        height: 35,
                                                        width: 250,
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("Ok"),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text("Submit Bet"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green)),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        )),
                        barrierColor: Colors.white.withOpacity(0.3));
                  }

                  // Submit end
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeAt(int index) {
    _betListModel.removeAt(index);
  }
}
