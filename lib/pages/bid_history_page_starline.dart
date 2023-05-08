import 'package:nsplay/models/bid_history_model.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';

import '../models/bet_number_starline_modal.dart';
import '../models/bid_history_starline_model.dart';

class BidHistoryStarline extends StatefulWidget {
  BidHistoryStarline({Key? key}) : super(key: key);

  @override
  _BidHistoryStarlineState createState() => _BidHistoryStarlineState();
}

class _BidHistoryStarlineState extends State<BidHistoryStarline> {
  double tableFontSize = 12;
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
  var _timelist = List<DropdownMenuItem<String>>.empty(growable: true).obs;
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
  var _selectTime = "all".obs;
  var _winLoosePanding = "all".obs;
  GenralApiCallService genralApiCallService = GenralApiCallService();
  final box = GetStorage();

  var futureResult = Future<List<StarlineBidHistoryModel>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = GameResultService();
    dropdownListType.add(DropdownMenuItem<String>(
      child: Text("Select Type"),
      value: "all",
    ));
    _timelist.add(DropdownMenuItem(value: "all", child: Text("Select Time")));

    getGameType();
  }

  getAllResut() {
    GameResultService.getStarlineBidHistory(
        date: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
        status: _winLoosePanding.value,
        time: _selectTime.value,
        user_id: box.read(StorageConstant.id));
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
    GameResultService.getStarlineTimeList().then(
      (value) {
        value!.forEach((element) {
          _timelist.add(DropdownMenuItem(
              value: element.time, child: Text(element.showTime!)));
        });
      },
    );

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
                Obx(
                  () => Container(
                    width: Get.width * 0.4,
                    padding: EdgeInsets.all(8),
                    child: DropdownButton<String>(
                        isExpanded: true,
                        onChanged: (value) {
                          _selectTime.value = value!;
                        },
                        value: _selectTime.value,
                        items: _timelist.map((val) => val).toList()),
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
                            var filter = "";
                            // var flag = true;
                            filter +=
                                " date = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and bid.status!='cancelled' ";
                            if (_selectedValue != "all") {
                              filter += " and game_id = '1'  ";
                            }
                            if (_winLoosePanding.value != "all") {
                              filter +=
                                  " and bid.status = '${_winLoosePanding.value}'  ";
                            }

                            setState(() {});
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
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<StarlineBidHistoryModel>?>(
                  future: GameResultService.getStarlineBidHistory(
                      date:
                          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}",
                      status: _winLoosePanding.value,
                      time: _selectTime.value,
                      user_id: box.read(StorageConstant.id)),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
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
                          List<StarlineBidHistoryModel>? finaldata =
                              snapshot.data;
                          print("FinalData::$finaldata");
                          return (finaldata!.length == 0)
                              ? Container(
                                  child: Text("No Data Found!!"),
                                )
                              : Container(
                                  child: Column(
                                    children: List.generate(finaldata.length,
                                        (index) {
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
                                                          "${finaldata[index].name} \n${finaldata[index].gameTypeFull} - ${finaldata[index].time} \nStatus : ${finaldata[index].winLoose} \nDate : ${finaldata[index].createdAt!.replaceFirst(" ", '\n')} \n"),
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
                                                                    width: 1))),
                                                        child: Center(
                                                          child: Text(
                                                              finaldata[index]
                                                                  .bidNumber!),
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
                                                      decoration: BoxDecoration(
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
