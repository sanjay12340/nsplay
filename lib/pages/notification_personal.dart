import 'dart:developer';

import 'package:nsplay/services/genral_api_call.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/models/personal_notification_model.dart';
import 'package:get/get.dart';
import 'package:nsplay/utils/mycontant.dart';

import '../utils/storage_constant.dart';

class PersolNotifiaction extends StatefulWidget {
  final String? pnotice;
  PersolNotifiaction({Key? key, this.pnotice = ""}) : super(key: key);

  @override
  _PersolNotifiactionState createState() => _PersolNotifiactionState();
}

class _PersolNotifiactionState extends State<PersolNotifiaction> {
  GenralApiCallService? genralApiCallService;
  var box = GetStorage();
  bool one = true;
  String sql = "";
  String sqlData = "";
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
    getNumberOffNotifiaction();
  }

  void getNumberOffNotifiaction() {
    if (widget.pnotice != null) {
      sql = widget.pnotice!;
      log(widget.pnotice!.toString(), name: "Personal Notice");

      // sqlData =
      //     "SELECT `id`, `notice`, `date`, `notice_to` FROM `live_notice` WHERE `id` in (select REPLACE(pnotice,'--',',') from user where user_id='${box.read(StorageConstant.id)}') order by id desc";
      sqlData =
          "SELECT ln.id, title, `notice`, `date`, `notice_to` , `view` FROM `user_notice` as un inner join live_notice as ln on ln.id=un.notice_id where user_id='${box.read(StorageConstant.id)}' order by ln.id desc limit 10";
      // "SELECT `id`, `notice`, `date`, `notice_to` FROM `live_notice` WHERE `id` in ($sql) order by id desc";
      log(sqlData, name: "Personal Notice sql");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back(canPop: true, result: true);
            }),
      ),
      body: (sql == "")
          ? const Center(
              child: Text("No Notification Found"),
            )
          : FutureBuilder(
              future:
                  genralApiCallService!.fetchGenralQueryWithRawData(sqlData),
              builder: (context, AsyncSnapshot<Object?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Container(child: Text("No Internet Conection")),
                    );

                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator()),
                    );

                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      log("Data Revieve", name: snapshot.data.toString());

                      List<PersonalNotifiactionModel> l =
                          personalNotifiactionModelFromJson(
                              snapshot.data.toString());
                      genralApiCallService!.fetchGenralQueryWithRawData(
                          "UPDATE `user` SET `pnotice` ='' WHERE user_id =${box.read('id')}");
                      box.write('pnotice', '');
                      return ListView.builder(
                          itemCount: l.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.red.shade50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Get.width,
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      myPrimaryColor
                                                          .withAlpha(25),
                                                  child: Icon(
                                                    Icons.notifications_on,
                                                    color: Colors.blue,
                                                    size: 28,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    l[index].title ?? '',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    l[index].notice!,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      "${l[index].date!.day}-${l[index].date!.month}-${l[index].date!.year}",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else
                      return Text("data hai ");

                  default:
                    return Text("data hai ");
                }
              },
            ),
    );
  }
}
