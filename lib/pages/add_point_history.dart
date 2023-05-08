import 'package:nsplay/models/get_transaction_model.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddPointHistory extends StatefulWidget {
  AddPointHistory({Key? key}) : super(key: key);

  @override
  _AddPointHistoryState createState() => _AddPointHistoryState();
}

class _AddPointHistoryState extends State<AddPointHistory> {
  double tableFontSize = 12;
  List<DropdownMenuItem<String>> dropdownList = [
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

  GameResultService? remoteGameResultService;

  GenralApiCallService genralApiCallService = GenralApiCallService();
  final box = GetStorage();
  var listResults = List<GetTransation>.empty(growable: true).obs;
  var futureResult = Future<List<GetTransation?>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = GameResultService();
    dropdownListType.add(DropdownMenuItem<String>(
      child: Text("Select Type"),
      value: "all",
    ));
  }

  Future<List<GetTransation?>?> fetchGameResults(String sql) async {
    return await genralApiCallService.fetchTransactionAddAmount(sql);
  }

  getAllResut(String sql) {
    futureResult.value = fetchGameResults(sql);
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
          "Add Point History",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(7)),
                    height: 40,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 20,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            Text(
                              " ${selectedDate.day}-${selectedDate.month}-${selectedDate.year} ",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                            color: myPrimaryColor,
                            borderRadius: BorderRadius.circular(7)),
                        child: TextButton(
                          child: Text(
                            "Submit",
                            style: TextStyle(color: myWhite, fontSize: 16),
                          ),
                          onPressed: () {
                            var filter = "";
                            // var flag = true;

                            filter +=
                                " date = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}' ";

                            String sql =
                                "SELECT `id`, `user_id` as userId, `c_amount` as cAmount , `credit`, `debit`, `final_amount` as finalAmount , `date`, date_format(`created_at`,'%d-%m-%Y %h:%i%p') as createdAt, `comment`, `uids` FROM `transaction`  WHERE comment LIKE '%add%' and  comment not like '%reject%' and " +
                                    filter +
                                    " and user_id = '${box.read("id")}' ORDER BY transaction.id DESC  ";
                            print(sql);
                            getAllResut(sql);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<GetTransation?>?>(
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
                            List<GetTransation?>? finaldata = snapshot.data;
                            print(
                                "Finad Lenght of data ----  ${finaldata!.length}");
                            finaldata = finaldata.map((i) {
                              if (i!.comment!.contains("manully")) {
                                i.comment = "manully";
                              } else if (i.comment!
                                  .toLowerCase()
                                  .contains("upi")) {
                                i.comment = "upi";
                              }
                              return i;
                            }).toList();
                            return (finaldata.length == 0)
                                ? Container(
                                    child: Text("No Data Found!!"),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                          width: Get.size.width,
                                          child: DataTable(
                                            columnSpacing: 4,
                                            headingRowColor:
                                                MaterialStateProperty.all(
                                                    Colors.amber.shade200),
                                            horizontalMargin: 0,
                                            border: TableBorder.all(
                                                color: Colors.black),
                                            columns: [
                                              DataColumn(
                                                  label: Expanded(
                                                      child: Text(
                                                "Money",
                                                textAlign: TextAlign.center,
                                              ))),
                                              DataColumn(
                                                  label: Expanded(
                                                      child: Text(
                                                "Via",
                                                textAlign: TextAlign.center,
                                              ))),
                                              DataColumn(
                                                  label: Expanded(
                                                      child: Text(
                                                "Time",
                                                textAlign: TextAlign.center,
                                              ))),
                                            ],
                                            rows: finaldata
                                                .map((e) => DataRow(cells: [
                                                      DataCell(
                                                          Center(
                                                            child: Text(
                                                                e!.credit!
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                          showEditIcon: false,
                                                          placeholder: false),
                                                      DataCell(
                                                          Center(
                                                            child: Text(e
                                                                .comment!
                                                                .toString()),
                                                          ),
                                                          showEditIcon: false,
                                                          placeholder: false),
                                                      DataCell(
                                                          Center(
                                                            child: Text(e
                                                                .createdAt!
                                                                .toString()
                                                                .replaceAll(
                                                                    " ", "\n")),
                                                          ),
                                                          showEditIcon: false,
                                                          placeholder: false),
                                                    ]))
                                                .toList(),
                                          ))
                                    ],
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
