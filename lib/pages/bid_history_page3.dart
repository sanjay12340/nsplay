import 'package:nsplay/models/bid_history_model.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BidHistory extends StatefulWidget {
  const BidHistory({Key? key}) : super(key: key);

  @override
  _BidHistoryState createState() => _BidHistoryState();
}

class _BidHistoryState extends State<BidHistory> {
  double tableFontSize = 12;
  List<DropdownMenuItem<String>> dropdownList = const [
    DropdownMenuItem(
      child: Text(
        "All Game",
        overflow: TextOverflow.ellipsis,
      ),
      value: "all",
    )
  ];

  List<DropdownMenuItem<String>> dropdownListType =
      List<DropdownMenuItem<String>>.empty(growable: true);
  final List<DropdownMenuItem<String>> _opneCloseList = const [
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
  final List<DropdownMenuItem<String>> _winLoosePandingList = const [
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
  var futureResult = Future<List<BidHistoryModel?>?>.value().obs;
  TextStyle gameStye = TextStyle(color: myWhite, fontSize: 15);
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

  Future<List<BidHistoryModel?>?> fetchGameResults(String sql) async {
    return await genralApiCallService.fetchGenralQuery(sql);
  }

  getAllResut(String sql) {
    futureResult.value = fetchGameResults(sql);
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
                Container(
                  width: Get.width * 0.4,
                  color: Colors.grey.shade300,
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "From ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      )),
                ),
                Container(
                  width: Get.width * 0.4,
                  color: Colors.grey.shade300,
                  height: 40,
                  child: GestureDetector(
                      onTap: () => _selectDate2(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "To ${selectedDate2.day}-${selectedDate2.month}-${selectedDate2.year} ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Theme.of(context).primaryColorDark,
                          )
                        ],
                      )),
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
            Container(
              width: Get.width * 0.9,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [myPrimaryColor, myAccentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: TextButton(
                child: Text(
                  "Go",
                  style: TextStyle(fontSize: 20, color: myWhite),
                ),
                onPressed: () {
                  var filter = "";
                  // var flag = true;
                  if (_selectedValue != "all") {
                    filter += " game_id = '$_selectedValue' and ";
                  }
                  if (_opneClose.value != "all") {
                    filter += " open_close = '${_opneClose.value}' and ";
                  }
                  if (_selectedValueType != "all") {
                    filter += "  game_type = '$_selectedValueType' and ";
                  }
                  if (_winLoosePanding.value != "all") {
                    filter += "  bid.status = '${_winLoosePanding.value}' and ";
                  }

                  filter +=
                      " date >= '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' and date <='${selectedDate2.year}-${selectedDate2.month}-${selectedDate2.day}' ";

                  String sql =
                      "SELECT `bid_id`, `bid_amount`, `game_id` , bid.status, `bid_game_number`, concat(`fn`,'-' ,`fno`, `snc`,'-' ,`sn`) as full, `open_close`, `game_type`, `win_amount`, `date`, user.usrname ,game.game_name FROM `bid` inner join user on user.user_id = bid.user_id INNER JOIN game on id = game_id WHERE " +
                          filter +
                          " and bid.user_id = '${box.read("id")}'";
                  print(sql);
                  getAllResut(sql);
                },
              ),
            ),
            Container(
                width: Get.size.width,
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text("Game Name"),
                          Text("Type" + " " + "Market"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("Status"),
                          Text("Number"),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("Bid"),
                          Text("WL Amt"),
                        ],
                      ),
                    ),
                  ],
                )),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<BidHistoryModel?>?>(
                    future: futureResult.value,
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
                            List<BidHistoryModel?>? finaldata = snapshot.data;
                            return (finaldata!.length == 0)
                                ? Container(
                                    child: Text("No Data Found!!"),
                                  )
                                : Column(
                                    children: List.generate(finaldata.length,
                                        (index) {
                                      return Container(
                                          width: Get.size.width,
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          decoration: BoxDecoration(
                                              color: myPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: myAccentColor
                                                              .withOpacity(.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7)),
                                                      child: Text(
                                                        finaldata[index]!
                                                            .gameName!,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: myWhite),
                                                      ),
                                                    ),
                                                    Text(
                                                        finaldata[index]!
                                                                .gameType! +
                                                            ", " +
                                                            finaldata[index]!
                                                                .openClose!,
                                                        style: gameStye),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      finaldata[index]!.status!,
                                                      style: gameStye,
                                                    ),
                                                    Text(
                                                        finaldata[index]!
                                                            .bidGameNumber!,
                                                        style:
                                                            gameStye.copyWith(
                                                          fontSize: 20,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        finaldata[index]!
                                                            .bidAmount!,
                                                        style:
                                                            gameStye.copyWith(
                                                                fontSize: 20)),
                                                    Text(
                                                      finaldata[index]!
                                                          .winAmount!,
                                                      style: gameStye.copyWith(
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ));
                                    }),
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
          ],
        ),
      ),
    );
  }

  TableCell myTableRaw(String text, bool type, bool leftcenter, double textsize,
      double padding) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        alignment: leftcenter ? Alignment.center : Alignment.topLeft,
        child: Text(
          text,
          textAlign: leftcenter ? TextAlign.center : TextAlign.left,
          style: TextStyle(fontSize: textsize),
        ),
      ),
    );
  }
}
