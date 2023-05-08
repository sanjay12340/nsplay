import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:nsplay/models/get_transaction_model.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/transaction_history_with_count.dart';
import '../models/transaction_modal.dart';

class TransactionHistory extends StatefulWidget {
  TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  double tableFontSize = 12;
  int limit = 50;
  int offset = 0;
  int totalRecord = 0;
  List<DropdownMenuItem<String>> dropdownList = const [
    DropdownMenuItem(
      value: "all",
      child: Text(
        "All Game",
        overflow: TextOverflow.ellipsis,
      ),
    )
  ];

  List<DropdownMenuItem<String>> dropdownListType =
      List<DropdownMenuItem<String>>.empty(growable: true);

  GameResultService? remoteGameResultService;

  GenralApiCallService generalApiCallService = GenralApiCallService();
  final box = GetStorage();
  var listResults = List<GetTransation>.empty(growable: true).obs;
  var futureResult = Future<List<TransactionHistoryModal>?>.value().obs;

  @override
  void initState() {
    super.initState();

    remoteGameResultService = GameResultService();
    dropdownListType.add(const DropdownMenuItem<String>(
      value: "all",
      child: Text("Select Type"),
    ));
  }

  Future<TransactionHistoryWithCount?> fetchGameResults(
      {String? date, String? limit, String? offset}) async {
    return await GameResultService.fetchTransactionWithCount(
        date: date, limit: limit, offset: offset);
  }

  getAllResult({String? date, String? limit, String? offset}) {
    fetchGameResults(date: date, limit: limit, offset: offset).then((value) {
      if (value != null) {
        futureResult.value = Future.value(value.transactionHistoryModal);
        setState(() {
          totalRecord = int.parse(value.total!);
        });
      } else {
        futureResult.value = Future.value([]);
        totalRecord = 0;
      }
    });
  }

  var selectedDate = DateTime.now();
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  var selectedDate2 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction",
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          children: [
            const SizedBox(
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
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
                            offset = 0;
                            getAllResult(
                                date: DateFormat("y-MM-d").format(selectedDate),
                                limit: limit.toString(),
                                offset: offset.toString());
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<TransactionHistoryModal>?>(
                    future: futureResult.value,
                    builder: (context, snapshot) {
                      if (kDebugMode) {
                        print(snapshot.connectionState);
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          if (kDebugMode) {
                            print("No Internet Connection");
                          }
                          break;
                        case ConnectionState.waiting:
                          return Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator());

                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            List<TransactionHistoryModal>? finaldata =
                                snapshot.data;
                            if (kDebugMode) {
                              print(
                                  "Finad Lenght of data ----  ${finaldata!.length}");
                            }

                            return (finaldata!.isEmpty)
                                ? const Text("No Data Found!!")
                                : Column(
                                    children: finaldata.map((e) {
                                    Color cbColor =
                                        (e.cd!.toLowerCase() == "credit")
                                            ? Colors.green
                                            : Colors.red;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        children: [
                                          Card(
                                            elevation: 8,
                                            clipBehavior: Clip.hardEdge,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: (e.transactionMode!
                                                        .contains(
                                                            "bid cancel by admin"))
                                                    ? Colors.red.shade50
                                                    : Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            e.cd!,
                                                            style: TextStyle(
                                                                color: cbColor),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          const Icon(
                                                            Icons
                                                                .currency_rupee,
                                                            size: 16,
                                                          ),
                                                          Text(
                                                              "${e.amount!} ${e.gameMode ?? ''}"),
                                                        ],
                                                      ),
                                                      Text(e.time!)
                                                    ],
                                                  ),
                                                  (e.transactionMode!.contains(
                                                          "bid cancel by admin"))
                                                      ? Text(e.transactionMode!)
                                                      : Container(),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  (e.transactionMode ==
                                                              "bid place" ||
                                                          e.transactionMode ==
                                                              "bid cancel by admin")
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Bid Play :",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                        "${e.bidGameNumber}"),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Type :",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                        " ${e.gameTypeFull}"),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Game :",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                        "${e.gameName}"),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Market :",
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                        "${e.openClose}"),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment: (e
                                                                  .comment!
                                                                  .contains(
                                                                      "win"))
                                                              ? MainAxisAlignment
                                                                  .spaceAround
                                                              : MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            (e.comment!
                                                                    .contains(
                                                                        "win"))
                                                                ? Image.asset(
                                                                    "assets/images/win.png",
                                                                    width: 50,
                                                                  )
                                                                : SizedBox(),
                                                            Text(
                                                              "${e.transactionMode!} ${e.bidDate != null ? '\nPlay Date : ' : ''} ${e.bidDate ?? ''}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        "Balance : ",
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        e.finalAmount!,
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList());
                          } else {
                            if (kDebugMode) {
                              print(snapshot.error);
                            }
                          }
                          break;
                        default:
                          if (snapshot.hasData) {
                            if (kDebugMode) {
                              print("has data Default");
                            }
                          } else {
                            if (kDebugMode) {
                              print(snapshot.error);
                            }
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
                      onPressed: offset == 0
                          ? null
                          : () {
                              if (offset > 0) {
                                offset = offset - 1;
                                getAllResult(
                                    date: DateFormat("y-MM-d")
                                        .format(selectedDate),
                                    limit: limit.toString(),
                                    offset: offset.toString());
                              }
                            },
                      child: const Text("Prev")),
                ),
                Expanded(
                    child: Center(
                        child: Text(
                            "Page : ${offset + 1} / ${(totalRecord / limit).ceil() + 1}  "))),
                Expanded(
                  child: ElevatedButton(
                      onPressed: totalRecord <= limit * offset
                          ? null
                          : () {
                              if ((totalRecord / limit) > offset) {
                                offset = offset + 1;
                                getAllResult(
                                    date: DateFormat("y-MM-d")
                                        .format(selectedDate),
                                    limit: limit.toString(),
                                    offset: offset.toString());
                              }
                            },
                      child: const Text("Next")),
                ),
              ],
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
