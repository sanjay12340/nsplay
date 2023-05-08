// import 'package:nsplay/models/bet_number_modal.dart';
import 'package:nsplay/models/game_play_condition_model.dart';
import 'package:nsplay/pages/Login.dart';
import 'package:nsplay/pages/half_sangam_close.dart';
import 'package:nsplay/pages/half_sangam_open.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:nsplay/utils/value_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:nsplay/models/game_result_model.dart';

import 'home_page.dart';

class HalfSangam extends StatefulWidget {
  final GameResultModel? gameResultModel;
  HalfSangam({Key? key, @required this.gameResultModel}) : super(key: key);

  @override
  _HalfSangamState createState() => _HalfSangamState();
}

class _HalfSangamState extends State<HalfSangam> {
  var balance = "0".obs;
  final box = GetStorage();

  // List<BetNumberModal> _betList = List<BetNumberModal>.empty(growable: true);

  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;

  var d = DateTime.now();

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();
  }

  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];

      box.write("money", map["money"].toString());
      setState(() {});
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
    // Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.gameResultModel!.gameName}, HALF SANGAM",
            style: TextStyle(fontSize: 15),
          ),
          bottom: TabBar(
            indicatorColor: myWhite,
            tabs: [
              Tab(
                text: "Open",
              ),
              Tab(
                text: "Close",
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: TabBarView(children: [
            HalfSangamOpen(
                gameResultModel: widget.gameResultModel,
                balance: balance.value),
            HalfSangamClose(
                gameResultModel: widget.gameResultModel,
                balance: balance.value),
          ]),
        ),
      ),
    );
  }
}
