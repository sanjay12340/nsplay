import 'package:flutter/foundation.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';

import '../models/bid_history_with_count_model.dart';

class BidHistory extends StatefulWidget {
  BidHistory({Key? key}) : super(key: key);

  @override
  _BidHistoryState createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  double tableFontSize = 12;
  int limit = 50;
  int offset = 0;
  int totalRecord = 0;
  List<DropdownMenuItem<String>> dropdownList = [
    DropdownMenuItem(
      child: Text(
        "Game",
        overflow: TextOverflow.ellipsis,
      ),
      value: "all",
    )
  ];

  List<DropdownMenuItem<String>> dropdownListType =
      List<DropdownMenuItem<String>>.empty(growable: true);
  List<DropdownMenuItem<String>> _opneCloseList = [
    DropdownMenuItem(
      child: Text("All"),
      value: "all",
    ),
    DropdownMenuItem(
      child: Text("Open"),
      value: "open",
    ),
    DropdownMenuItem(
      child: Text("Close"),
      value: "close",
    ),
  ];
  List<DropdownMenuItem<String>> _winLoosePandingList = [
    DropdownMenuItem(
      child: Text("All"),
      value: "all",
    ),
    DropdownMenuItem(
      child: Text("Win"),
      value: "win",
    ),
    DropdownMenuItem(
      child: Text("Loose"),
      value: "loose",
    ),
    DropdownMenuItem(
      child: Text("Pending"),
      value: "pending",
    ),
  ];

  GameResultService? remoteGameResultService;

  var _selectedValue = "all";
  var _selectedValueType = "all";
  var _opneClose = "all".obs;
  var _winLoosePanding = "all".obs;
  GenralApiCallService genralApiCallService = GenralApiCallService();
  final box = GetStorage();
  var listResults = List<BidHistoryModel>.empty(growable: true).obs;
  var futureResult = Future<List<BidHistoryModel>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = GameResultService();
    dropdownListType.add(DropdownMenuItem<String>(
      child: Text("Select Type"),
      value: "all",
    ));
    getGameType();
  }

  Future<BidHistoryWithCountModel?> fetchGameResults(
      {String? userId,
      String? date,
      String? openClose,
      String? status,
      String? gameId,
      String? gameType,
      int? limit,
      int? offset}) async {
    return await GameResultService.fetchBidHistory(
        date: date,
        gameId: gameId,
        gameType: gameType,
        limit: limit,
        offset: offset,
        openClose: openClose,
        status: status,
        userId: userId);
  }

  getAllResut(
      {String? userId,
      String? date,
      String? openClose,
      String? status,
      String? gameId,
      String? gameType,
      int? limit,
      int? offset}) {
    fetchGameResults(
            date: date,
            gameId: gameId,
            gameType: gameType,
            limit: limit,
            offset: offset,
            openClose: openClose,
            status: status,
            userId: userId)
        .then((value) {
      if (value != null) {
        if (value.results != null) {
          futureResult.value = Future.value(value.results);
        } else {
          futureResult.value = Future.value([]);
        }
        setState(() {
          totalRecord = int.parse(value.count!);
        });
      } else {
        futureResult.value = Future.value([]);
        setState(() {
          totalRecord = 0;
        });
      }
    });
  }

  getGameType() async {
    await remoteGameResultService!.fetchGameType().then((value) {
      value!.gameTypeModel!.forEach((element) {
        dropdownListType.add(DropdownMenuItem<String>(
          child: Text(element.fname!),
          value: element.name,
        ));
      });
      value.game!.forEach((element) {
        dropdownList.add(DropdownMenuItem(
          child: Text(
            "${element.gameName}",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(),
          ),
          value: element.id,
        ));
      });
    });

    setState(() {});
  }

  var selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  var selectedDate2 = DateTime.now();
  _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bid History",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: Get.width * 0.4,
                  padding: EdgeInsets.all(8),
                  child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: (value) {
                        _selectedValue = value!;
                        setState(() {});
                      },
                      value: _selectedValue,
                      items: dropdownList.map((val) => val).toList()),
                ),
                Container(
                  width: Get.width * 0.4,
                  child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: (value) {
                        _selectedValueType = value!;
                        setState(() {});
                      },
                      value: _selectedValueType,
                      items: dropdownListType.map((val) => val).toList()),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(
                  () => Container(
                    width: Get.width * 0.4,
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (value) {
                          _opneClose.value = value!;
                        },
                        value: _opneClose.value,
                        items: _opneCloseList.map((val) => val).toList()),
                  ),
                ),
                Obx(
                  () => Container(
                    width: Get.width * 0.4,
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (value) {
                          _winLoosePanding.value = value!;
                        },
                        value: _winLoosePanding.value,
                        items: _winLoosePandingList.map((val) => val).toList()),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.yellow.shade300,
                          borderRadius: BorderRadius.circular(8)),
                      height: 40,
                      child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/iwatch.png",
                                height: 100,
                              ),
                              Text(
                                " ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} ",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(color: myPrimaryColor),
                        child: TextButton(
                          child:
                              Text("Search", style: TextStyle(color: myWhite)),
                          onPressed: () {
                            offset = 0;
                            getAllResut(
                                userId: box.read(StorageConstant.id),
                                date:
                                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                gameId: _selectedValue == "all"
                                    ? null
                                    : _selectedValue,
                                gameType: _selectedValueType == "all"
                                    ? null
                                    : _selectedValueType,
                                openClose: _opneClose.value == "all"
                                    ? null
                                    : _opneClose.value,
                                status: _winLoosePanding.value == "all"
                                    ? null
                                    : _winLoosePanding.value,
                                limit: limit,
                                offset: offset);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Table(border: TableBorder.all(), columnWidths: {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(0.8),
                2: FlexColumnWidth(0.6),
                3: FlexColumnWidth(0.6),
              }, children: [
                TableRow(children: [
                  myTableRawHead("Game", true, true, 15, 20),
                  myTableRawHead("Number", true, true, 15, 10),
                  myTableRawHead("Bid", true, true, 15, 10),
                  myTableRawHead("Win", true, true, 15, 10),
                ]),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<BidHistoryModel>?>(
                    future: futureResult.value,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          print("No Internet Connection");
                          break;
                        case ConnectionState.waiting:
                          return Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<BidHistoryModel>? finaldata = snapshot.data;
                            return (finaldata!.length == 0)
                                ? Container(
                                    child: Text("No Data Found!!"),
                                  )
                                : Container(
                                    child: Column(
                                      children: List.generate(finaldata.length,
                                          (index) {
                                        var gameNumber = (finaldata[index]
                                                    .bidGameNumber ==
                                                "")
                                            ? finaldata[index].full
                                            : finaldata[index].bidGameNumber;
                                        return Card(
                                          elevation: 8,
                                          child: Column(children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      flex: 50,
                                                      child: Center(
                                                        child: Text(
                                                            "${finaldata[index].gameName} \n${finaldata[index].gameTypeFull} - ${finaldata[index].openClose} \nStatus : ${finaldata[index].status} \nDate : ${finaldata[index].createeAt!.replaceFirst(" ", '\n')} \n"),
                                                      )),
                                                  Expanded(
                                                      flex: 20,
                                                      child: Container(
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1),
                                                                  left: BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1))),
                                                          child: Center(
                                                            child: Text(
                                                                gameNumber!),
                                                          ))),
                                                  Expanded(
                                                      flex: 15,
                                                      child: Container(
                                                        height: 100,
                                                        child: Center(
                                                          child: Text(
                                                              finaldata[index]
                                                                  .bidAmount!),
                                                        ),
                                                      )),
                                                  Expanded(
                                                      flex: 15,
                                                      child: Container(
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1),
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            finaldata[index]
                                                                .winAmount!,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        );
                                      }),
                                    ),
                                  );
                          } else {
                            print(snapshot.error);
                          }
                          break;
                        default:
                          if (snapshot.hasData) {
                            print("has data Default");
                          } else {
                            print(snapshot.error);
                          }
                      }

                      return Container();
                    },
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: offset <= 0
                          ? null
                          : () {
                              var filter = "";
                              if (offset > 0) {
                                offset = offset - 1;
                              }
                              filter +=
                                  " date = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and bid.status!='cancelled' ";
                              if (_selectedValue != "all") {
                                filter += " and game_id = '$_selectedValue'  ";
                              }
                              if (_opneClose.value != "all") {
                                filter +=
                                    " and open_close = '${_opneClose.value}'  ";
                              }
                              if (_selectedValueType != "all") {
                                filter +=
                                    " and game_type = '$_selectedValueType'  ";
                              }
                              if (_winLoosePanding.value != "all") {
                                filter +=
                                    " and bid.status = '${_winLoosePanding.value}'  ";
                              }

                              getAllResut(
                                  userId: box.read(StorageConstant.id),
                                  date:
                                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                  gameId: _selectedValue == "all"
                                      ? null
                                      : _selectedValue,
                                  gameType: _selectedValueType == "all"
                                      ? null
                                      : _selectedValueType,
                                  openClose: _opneClose.value == "all"
                                      ? null
                                      : _opneClose.value,
                                  status: _winLoosePanding.value == "all"
                                      ? null
                                      : _winLoosePanding.value,
                                  limit: limit,
                                  offset: offset);
                            },
                      child: Text("Prev")),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                            "Page : ${offset + 1} / ${(totalRecord / limit).ceil()}  "))),
                Expanded(
                  child: ElevatedButton(
                      onPressed: totalRecord <= limit * offset
                          ? null
                          : () {
                              if ((totalRecord / limit) > offset) {
                                offset = offset + 1;
                              }
                              var filter = "";
                              // var flag = true;
                              filter +=
                                  " date = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and bid.status!='cancelled' ";
                              if (_selectedValue != "all") {
                                filter += " and game_id = '$_selectedValue'  ";
                              }
                              if (_opneClose.value != "all") {
                                filter +=
                                    " and open_close = '${_opneClose.value}'  ";
                              }
                              if (_selectedValueType != "all") {
                                filter +=
                                    " and game_type = '$_selectedValueType'  ";
                              }
                              if (_winLoosePanding.value != "all") {
                                filter +=
                                    " and bid.status = '${_winLoosePanding.value}'  ";
                              }

                              getAllResut(
                                  userId: box.read(StorageConstant.id),
                                  date:
                                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                                  gameId: _selectedValue == "all"
                                      ? null
                                      : _selectedValue,
                                  gameType: _selectedValueType == "all"
                                      ? null
                                      : _selectedValueType,
                                  openClose: _opneClose.value == "all"
                                      ? null
                                      : _opneClose.value,
                                  status: _winLoosePanding.value == "all"
                                      ? null
                                      : _winLoosePanding.value,
                                  limit: limit,
                                  offset: offset);
                            },
                      child: Text("Next")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  TableCell myTableRaw(String text, bool type, bool leftcenter, double textsize,
      double padding) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Card(
        elevation: 8,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
          ),
          alignment: leftcenter ? Alignment.center : Alignment.topLeft,
          child: Text(
            text,
            textAlign: leftcenter ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: textsize,
            ),
          ),
        ),
      ),
    );
  }
}

TableCell myTableRawHead(
    String text, bool type, bool leftcenter, double textsize, double padding) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      color: myPrimaryColorDark,
      height: 40,
      alignment: leftcenter ? Alignment.center : Alignment.topLeft,
      child: Text(
        text,
        textAlign: leftcenter ? TextAlign.center : TextAlign.left,
        style: TextStyle(fontSize: textsize, color: myWhite),
      ),
    ),
  );
}
