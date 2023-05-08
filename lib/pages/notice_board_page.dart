import 'dart:convert';

import 'package:nsplay/services/genral_api_call.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeBoardPage extends StatefulWidget {
  NoticeBoardPage({Key? key}) : super(key: key);

  @override
  _NoticeBoardPageState createState() => _NoticeBoardPageState();
}

class _NoticeBoardPageState extends State<NoticeBoardPage> {
  GenralApiCallService? g;
  var _notice = "".obs;
  var _waiting = true.obs;
  getNotice() {
    String sql =
        "SELECT `notice_id`, `notice`, `notice_date` FROM `notice` WHERE `notice_id`=1";
    g!.fetchGenralQueryWithRawData(sql).then((value) {
      var data = jsonDecode(value);
      _waiting.value = !_waiting.value;
      _notice.value = data[0]['notice'];
    });
  }

  @override
  void initState() {
    super.initState();
    g = GenralApiCallService();
    getNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice Board"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => (_waiting.value)
                ? Expanded(
                    child: Container(
                    width: Get.width,
                    child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  ))
                : Expanded(
                    child: Container(
                    alignment: Alignment.topCenter,
                    color: Colors.black87,
                    padding: EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      child: Container(
                          width: Get.width * 0.9,
                          child: Text(
                            "${_notice.value.replaceAll("<br>", "\n")}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  )),
          )
        ],
      ),
    );
  }
}
