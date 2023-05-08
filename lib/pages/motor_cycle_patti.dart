// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:nsplay/models/bet_number_modal.dart';
import 'package:nsplay/models/game_play_condition_model.dart';
import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/my_box_modal.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/play_bet_service.dart';
import 'package:nsplay/utils/game_type_card.dart';
import 'package:nsplay/utils/mycontant.dart';
import '../mywidgets/auto_suggest.dart';
import '../mywidgets/generated_Number_with_Type.dart';
import '../mywidgets/show_expended.dart';
import '../mywidgets/walet_deduction_widget.dart';
import '../utils/motor/genrate_sp_motor.dart';
import '../utils/pana_list.dart';
import '../utils/storage_constant.dart';

class CyclePatti extends StatefulWidget {
  final GameResultModel? gameResultModel;
  final String? openClose;
  CyclePatti(
      {Key? key, @required this.gameResultModel, required this.openClose})
      : super(key: key);

  @override
  _CyclePattiState createState() => _CyclePattiState();
}

class _CyclePattiState extends State<CyclePatti> {
  var balance = "0".obs;
  final box = GetStorage();
  final List<MyBox> n = [];

  final List<BetNumberModal> _betList =
      List<BetNumberModal>.empty(growable: true);

  GameResultService? rgrs;
  GamePlayConditionModel? gpcm;
  var isWaiting = true.obs;

  var opneClose = ["Select Market"].obs;
  final _selectedValue = "Select Market".obs;
  final List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  final TextEditingController _number = TextEditingController();
  final TextEditingController _point = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _genNumberClass =
      List<GenratedNumberWithGameType>.empty(growable: true).obs;

  final String _gametype = "Cycle Patti";
  final String _gametypedb = "cycle_patti";

  @override
  void initState() {
    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    super.initState();
    final box = GetStorage();
    balance.value = box.read("money").toString();
    getBalance();
    if (widget.openClose == "open") {
      opneClose.value = ["open", "close"];
    } else {
      opneClose.value = ["close"];
    }
    _selectedValue.value = opneClose[0];
  }

  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs!.checkBalance();
    if (map["status"]) {
      balance.value = map["money"];

      box.write("money", map["money"].toString());
    }

    gpcm =
        await rgrs!.checkPlayCondtion(int.parse(widget.gameResultModel!.id!));
    if (gpcm!.playstatus!) {
      if (gpcm!.playoc == "open_only") {
        opneClose.value = ['open'];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else if (gpcm!.playoc == "open") {
        opneClose.value = ["open", "close"];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      } else if (gpcm!.playoc == "close") {
        opneClose.value = ["close"];
        _selectedValue.value = opneClose[0];
        isWaiting.value = false;
      }
    } else {
      Get.back();
    }
  }

  Future<Map<String, dynamic>> submitbet(List<BetNumberModal> myjson) async {
    Map<String, dynamic> m = await PlayBet.playBetGame(myjson);
    return m;
  }

  void addGenClass(GenratedNumberWithGameType GenratedNumberWithGameType) {
    _genNumberClass.add(GenratedNumberWithGameType);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var d = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.gameResultModel!.gameName}, ${_gametype}".toUpperCase(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          color: myPrimaryColor.withOpacity(0.1),
          child: Column(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/calendar.png",
                              scale: 1.8,
                            ),
                            Text(
                              "${DateFormat("d MMM y").format(d)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Obx(
                          () => Container(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
              SizedBox(
                height: 10,
              ),
              Container(
                height: 70,
                width: Get.size.width,
                color: myWhite,
                child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: EasyAutocomplete(
                                keyboardType: TextInputType.number,
                                maxLength: 2,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _number,
                                suggestionTextStyle: TextStyle(fontSize: 18),
                                suggestions: cyclePatti,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Not valid";
                                  } else if (val.length != 2) {
                                    return "Not valid";
                                  } else if (!cyclePatti.contains(val)) {
                                    return "Not valid patti";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, top: 25, left: 10),
                                    isDense: true,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "CP",
                                    labelText: "CP"),
                                onChanged: (value) {},
                                onSubmitted: (value) =>
                                    print('onSubmitted value: $value'),
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                cursorColor: myBlack,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    focusColor: myAccentColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: myAccentColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      borderSide: const BorderSide(),
                                    ),
                                    hintText: "Point",
                                    labelText: "Point",
                                    labelStyle: TextStyle(
                                        color: _focusNodes[1].hasFocus
                                            ? myAccentColor
                                            : myBlack)),
                                controller: _point,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText: "Min point should 10");
                                    return "Filed not Empity";
                                  } else if (val.length < 2) {
                                    Get.defaultDialog(
                                        title: "Alert",
                                        middleText: "Min point should 10");
                                    return "Point Should be Greater then 9";
                                  }
                                  return null;
                                },
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Container(
                                color: myPrimaryColorDark,
                                child: TextButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        // ignore: unrelated_type_equality_checks
                                        if (_selectedValue != "Select Market") {
                                          int mypoint = int.parse(_point.text);
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          _genNumberClass.clear();
                                          List<Map<String, String>> list =
                                              GenrateMotorNumber.cyclePatti(
                                                  _number.text.toString());
                                          for (var item in list) {
                                            addGenClass(
                                                GenratedNumberWithGameType(
                                              number: item['pana']!,
                                              point: mypoint,
                                              gameType: item['game_type'],
                                            ));
                                          }

                                          Get.bottomSheet(Container(
                                            height: Get.size.height,
                                            width: Get.width,
                                            decoration:
                                                BoxDecoration(color: myWhite),
                                            child: Obx(
                                              () => Column(
                                                children: [
                                                  Container(
                                                    width: Get.size.width,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: myBlack),
                                                    child: Row(
                                                      children: [
                                                        headingMethod(
                                                            _gametype),
                                                        headingMethod("Point"),
                                                        headingMethod("Delete"),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                    child: Column(
                                                        children: List.generate(
                                                            _genNumberClass
                                                                .length,
                                                            (index) {
                                                      return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 5),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border:
                                                                      Border(
                                                            bottom: BorderSide(
                                                              //                   <--- left side
                                                              color:
                                                                  Colors.black,
                                                              width: 1.0,
                                                            ),
                                                          )),
                                                          child: Row(children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child:
                                                                  _genNumberClass[
                                                                      index],
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    _genNumberClass
                                                                        .removeAt(
                                                                            index);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete)),
                                                            ),
                                                          ]));
                                                    })),
                                                  )),
                                                  SizedBox(
                                                    height: 50,
                                                    width: Get.width,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Colors.red,
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 10,
                                                            ),
                                                            child: TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color:
                                                                        myWhite),
                                                              ),
                                                            )),
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.green,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 0,
                                                            horizontal: 10,
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              _betList.clear();
                                                              Get.back();
                                                              int total = 0;
                                                              _genNumberClass
                                                                  .forEach((i) {
                                                                if (i.pointController!
                                                                        .text
                                                                        .toString() !=
                                                                    "") {
                                                                  if (int.parse(i
                                                                          .pointController!
                                                                          .text
                                                                          .toString()) >
                                                                      9) {
                                                                    total += int.parse(i
                                                                        .pointController!
                                                                        .text
                                                                        .toString());
                                                                    _betList.add(
                                                                        BetNumberModal(
                                                                      gameid: int.parse(widget
                                                                          .gameResultModel!
                                                                          .id!),
                                                                      openclose:
                                                                          _selectedValue
                                                                              .value,
                                                                      date:
                                                                          "${d.day}/${d.month}/${d.year}",
                                                                      gametype:
                                                                          i.gameType!,
                                                                      gametypefull:
                                                                          "Cycle Patti",
                                                                      number: i
                                                                          .number
                                                                          .toString(),
                                                                      price: int.parse(i
                                                                          .pointController!
                                                                          .text
                                                                          .toString()),
                                                                      userid: int.parse(
                                                                          box.read(
                                                                              "id")),
                                                                    ));
                                                                  }
                                                                }
                                                              });

                                                              if (total <=
                                                                  int.parse(balance
                                                                      .value)) {
                                                                if (total > 9) {
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        Dialog(
                                                                      insetPadding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              2),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      clipBehavior:
                                                                          Clip.hardEdge,
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        height: Get.height -
                                                                            Get.height *
                                                                                0.09,
                                                                        width: Get.width -
                                                                            10,
                                                                        child: Column(
                                                                            children: [
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
                                                                                        .map(
                                                                                          (e) => ShowGamePlayText(digit: e.number!, point: e.price.toString(), type: e.openclose),
                                                                                        )
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
                                                                                            flex: 1,
                                                                                            child: Text("Total Bids"),
                                                                                          ),
                                                                                          Expanded(
                                                                                              flex: 1,
                                                                                              child: Text(
                                                                                                _betList.length.toString(),
                                                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          const Expanded(
                                                                                            flex: 1,
                                                                                            child: Text("Total Bid\nAmount"),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Text(
                                                                                              total.toString(),
                                                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ),
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
                                                                                            child: Text("Wallet\nBalance\nBefore\nDeduction"),
                                                                                          ),
                                                                                          Expanded(flex: 1, child: Text(box.read(StorageConstant.money), style: const TextStyle(fontWeight: FontWeight.bold))),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          const Expanded(
                                                                                            flex: 1,
                                                                                            child: Text("Wallet\nBalance\nAter\nDeduction"),
                                                                                          ),
                                                                                          Expanded(
                                                                                            flex: 1,
                                                                                            child: Text((int.parse(box.read(StorageConstant.money)) - total).toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              const Text("*Note: Bid once played cannot be cancelled*", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
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
                                                                                                  Expanded(child: Text("please Wait Bet is Processing"))
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                          Map m = await submitbet(_betList);
                                                                                          if (m["status"]) {
                                                                                            Get.back();

                                                                                            showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return Dialog(
                                                                                                    child: Container(
                                                                                                      width: Get.width - 30,
                                                                                                      decoration: BoxDecoration(color: myWhite, borderRadius: BorderRadius.circular(8)),
                                                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
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
                                                                                                            style: TextStyle(color: Colors.green),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 35,
                                                                                                            width: 250,
                                                                                                            child: ElevatedButton(
                                                                                                              onPressed: () {
                                                                                                                if (Get.isDialogOpen!) {
                                                                                                                  Get.back();
                                                                                                                }

                                                                                                                box.write("money", (int.parse(balance.value) - total).toString());
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
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
                                                                                                      decoration: BoxDecoration(color: myWhite, borderRadius: BorderRadius.circular(8)),
                                                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
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
                                                                                                            style: TextStyle(color: Colors.red),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: 35,
                                                                                                            width: 250,
                                                                                                            child: ElevatedButton(
                                                                                                              onPressed: () {
                                                                                                                if (Get.isDialogOpen!) {
                                                                                                                  Get.back();
                                                                                                                }

                                                                                                                if (Get.isDialogOpen!) {
                                                                                                                  Get.back();
                                                                                                                }

                                                                                                                if (Get.isDialogOpen!) {
                                                                                                                  Get.back();
                                                                                                                }

                                                                                                                if (Get.isDialogOpen!) {
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
                                                                                        style: ElevatedButton.styleFrom(primary: Colors.green),
                                                                                        child: const Text("Submit Bet")),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  Get.defaultDialog(
                                                                      title: "Alert",
                                                                      middleText: (total > 9)
                                                                          ? "Select Bazar"
                                                                          : (int.parse(balance.value) < 10)
                                                                              ? "You dont have enough point to play please Recharge"
                                                                              : "Please select at least one number min 10 point");
                                                                }
                                                              } else {
                                                                Get.defaultDialog(
                                                                    title:
                                                                        "Alert",
                                                                    middleText:
                                                                        "Insuficiant Fund");
                                                              }
                                                            },
                                                            child: Text(
                                                                "Submit",
                                                                style: TextStyle(
                                                                    color:
                                                                        myWhite)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                        } else {
                                          Get.defaultDialog(
                                              title: "Alert",
                                              middleText:
                                                  "Please Select Market");
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Genrate",
                                      style: TextStyle(color: myWhite),
                                    )),
                              ),
                            )),
                      ],
                    )),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ));
  }

  Widget betInformation({String? msg = ""}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(msg!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Expanded headingMethod(String name) {
    return Expanded(
        child: Center(child: Text(name, style: TextStyle(color: myWhite))));
  }
}
