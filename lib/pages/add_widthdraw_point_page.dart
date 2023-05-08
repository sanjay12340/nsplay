import 'dart:convert';
import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:nsplay/models/settings_model.dart';
import 'package:nsplay/pages/home_page.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:nsplay/models/add_withdraw_model.dart';
import 'package:nsplay/utils/storage_constant.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/rules_model.dart';
import '../mywidgets/balance_show_widget.dart';
import 'add_point_history.dart';
import 'widthdraw_point_history.dart';

class AddWidthdrawPage extends StatefulWidget {
  final String name;
  final String addWidthdraw;
  final String requestType;
  final String requestTypeFullName;
  final String adminwp;

  AddWidthdrawPage(
      {Key? key,
      required this.addWidthdraw,
      required this.requestType,
      required this.requestTypeFullName,
      required this.adminwp,
      required this.name})
      : super(key: key);

  @override
  _AddWidthdrawPageState createState() => _AddWidthdrawPageState();
}

class _AddWidthdrawPageState extends State<AddWidthdrawPage> {
  var box = GetStorage();
  GenralApiCallService? genralApiCallService;
  var _formState = GlobalKey<FormState>();
  var _selectedItem = "no".obs;
  var _amount = TextEditingController();
  var _phone = TextEditingController();
  var _personName = TextEditingController();
  List<String> rules = [];
  TextStyle headingTextStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle headingTextStyle2 =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  double minWithdraw = 300;
  bool click = true;
  @override
  void initState() {
    super.initState();

    genralApiCallService = GenralApiCallService();
    fetchSettings();
    fetchAddMoneyrules();
  }

  fetchAddMoneyrules() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT  `text` FROM `rules` where name='withdraw Money' order by id")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      if (data != null) {
        rulesFromJson(value).forEach((element) {
          rules.add(element.text!);
        });

        setState(() {});
        print(rules);
      }
    });
  }

  Future<void> fetchSettings() async {
    List<SettingsModel>? listSettingModel =
        await GenralApiCallService.fetchSettings('money', 'Min Withdraw');
    if (listSettingModel != null) {
      for (var element in listSettingModel) {
        minWithdraw =
            element.id == "2" ? double.parse(element.value!) : minWithdraw;
      }
    }
  }

  Future<String> getData() async {
    String sql =
        "SELECT `wr_id`, `w_user_id`, `r_money`, `r_type`, `r_type2`, `payment_type`, `payment_link`, `status`, date_format(`created_at`,'%d-%m-%Y \n %h:%i %p') as created_at, date_format(`update_at`,'%d-%m-%Y \n %h:%i %p') as update_at FROM `wallet_request` WHERE `w_user_id` =${box.read('id')} and r_type='${widget.requestType}' order by wr_id desc LIMIT 40";
    print(sql);
    return await genralApiCallService!.fetchGenralQueryWithRawData(sql);
  }

  void _launchURLWhatsApp() async => await canLaunch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi")
      ? await launch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi")
      : throw 'Could not launch https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi';
  void _launchURLPhone() async => await canLaunch(
          "tel:${box.read(StorageConstant.adminPhone)}")
      ? await launch("tel:${box.read(StorageConstant.adminPhone)}")
      : throw 'Could not launch tel:${box.read(StorageConstant.adminPhone)}';

  void _launchURLWhatsAppNotification() async => await canLaunch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Amount widthddraw request\n Name: ${_personName.text}\n Amount: ${_amount.text}\n Phone:${_phone.text}\n Payment Mode:${_selectedItem.value} ")
      ? await launch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Amount widthddraw request\n Name: ${_personName.text}\n Amount: ${_amount.text}\n Phone:${_phone.text}\n Payment Mode:${_selectedItem.value} ")
      : throw 'Could not launch https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?textAmount widthddraw request\n Name: ${_personName.text}\n Amount: ${_amount.text}\n Phone:${_phone.text}\n Payment Mode:${_selectedItem.value} ';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.offAll(() => HomePage());
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.addWidthdraw.toUpperCase()}"),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: Get.size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //     alignment: Alignment.center,
                  //     color: myPrimaryColor,
                  //     width: Get.width,
                  //     padding: EdgeInsets.all(10),
                  //     child: Text(
                  //       "${widget.addWidthdraw} Request",
                  //       style: TextStyle(color: Colors.white, fontSize: 16),
                  //     )),
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
                    child: BalanceShowWidget(
                        balance: box.read(StorageConstant.money)),
                  ),
                  Container(
                    width: Get.width,
                    child: Form(
                      key: _formState,
                      child: Column(
                        children: [
                          widget.name.toLowerCase().contains("withdraw")
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: TextFormField(
                                        controller: _personName,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            labelText: "Name",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        300))),
                                        validator: (val) {
                                          return val == "" ? "Type name" : null;
                                        },
                                      ),
                                    )),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _amount,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Amount",
                                      labelText: "Amount",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(300))),
                                  validator: (widget.name.toLowerCase() ==
                                          "withdraw")
                                      ? (val) {
                                          if (val == "") {
                                            return "Min $minWithdraw";
                                          }
                                          if (int.parse(val!) < minWithdraw) {
                                            return "Min $minWithdraw";
                                          } else
                                            return null;
                                        }
                                      : (val) {
                                          if (val == "") {
                                            return "Min 500";
                                          }
                                          if (int.parse(val!) < 500) {
                                            return "Min 500";
                                          } else
                                            return null;
                                        },
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  controller: _phone,
                                  validator: (val) {
                                    if (val!.length == 10) {
                                      return null;
                                    } else
                                      return "Invalid Number";
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "Phone Number",
                                      labelText: "Phone Number",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(300))),
                                ),
                              )),
                            ],
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Expanded(
                                    child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(300)),
                                      isDense: true,
                                    ),
                                    validator: (val) {
                                      if (val == "no") {
                                        return "Select Payment Mode";
                                      }
                                      return null;
                                    },
                                    value: _selectedItem.value.toString(),
                                    onChanged: (val) {
                                      _selectedItem.value = val!;
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        child: Text(
                                          "Select Mode",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        value: "no",
                                      ),
                                      DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/svg/paytm.svg",
                                              height: 20,
                                              width: 100,
                                              color: myPrimaryColor,
                                            ),
                                          ],
                                        ),
                                        value: "paytm",
                                      ),
                                      DropdownMenuItem(
                                        child: SvgPicture.asset(
                                          "assets/svg/gpay.svg",
                                          height: 30,
                                          width: 100,
                                        ),
                                        value: "gpay",
                                      ),
                                      DropdownMenuItem(
                                        child: SvgPicture.asset(
                                          "assets/svg/phonepe.svg",
                                          height: 20,
                                          width: 100,
                                        ),
                                        value: "phonepe",
                                      ),
                                      DropdownMenuItem(
                                        child: SvgPicture.asset(
                                          "assets/svg/upi2.svg",
                                          height: 25,
                                          width: 175,
                                        ),
                                        value: "upi",
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                              Expanded(
                                  child: Container(
                                padding: EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: myPrimaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextButton(
                                    child: Text(
                                      "Send Request",
                                      style: TextStyle(color: myWhite),
                                    ),
                                    onPressed: () {
                                      if (_formState.currentState!.validate()) {
                                        var d = DateTime.now();
                                        String fullDate =
                                            "${d.year}-${(d.month < 10) ? "0" + d.month.toString() : d.month}-${(d.day < 10) ? "0" + d.day.toString() : d.day} ${(d.hour < 10) ? "0" + d.hour.toString() : d.hour}:${(d.minute < 10) ? "0" + d.minute.toString() : d.minute}:${(d.second < 10) ? "0" + d.second.toString() : d.second}";

                                        String sql = "";

                                        sql =
                                            "INSERT INTO `wallet_request`(`w_user_id`, `r_money`, `r_type`, `r_type2`, `payment_type`, `payment_link`,  date_format(`created_at`,'%d-%m-%Y \n %h:%i %p') as created_at, date_format(`update_at`,'%d-%m-%Y \n %h:%i %p') as update_at) VALUES ('${box.read('id')}','${_amount.text.toString()}','${widget.requestType.toString()}','${widget.requestTypeFullName..toString()}','${_selectedItem.value.toString()}', '${_phone.text.toString()}','$fullDate','$fullDate')";

                                        bool
                                            IsWithdrawReqAskLargeMoneyThenPresent =
                                            true;
                                        String msg = "";

                                        if (widget.name
                                            .toLowerCase()
                                            .contains("withdraw")) {
                                          log(widget.name,
                                              name:
                                                  "Request Type Inside widthdraw");
                                          if (int.parse(box.read(
                                                  StorageConstant.money)) <
                                              int.parse(_amount.text)) {
                                            IsWithdrawReqAskLargeMoneyThenPresent =
                                                false;
                                            msg =
                                                "Ask money is greater then balance";
                                          }
                                        }
                                        if (IsWithdrawReqAskLargeMoneyThenPresent) {
                                          GenralApiCallService.withdrawReuest(
                                                  name: _personName.text,
                                                  paymentLink:
                                                      _phone.value.text,
                                                  paymentType:
                                                      _selectedItem.value,
                                                  rMoney: _amount.text,
                                                  rType2: widget
                                                      .requestTypeFullName,
                                                  rType: widget.requestType)
                                              .then((value) {
                                            log(value.toString(),
                                                error: true,
                                                name: "Save Request");
                                            var data = value;
                                            print("data  $data");
                                            if (data!['status']) {
                                              int money =
                                                  int.parse(box.read("money"));
                                              int money2 =
                                                  int.parse(_amount.text);
                                              int total = money - money2;
                                              box.write("money", "$total");

                                              Get.defaultDialog(
                                                  title: "Alert",
                                                  middleText: (widget.name
                                                              .toLowerCase() ==
                                                          "withdraw")
                                                      ? "withdrawal request successful"
                                                      : "Add request successful",
                                                  textConfirm: "Ok",
                                                  onConfirm: () {
                                                    _launchURLWhatsAppNotification();
                                                    Get.back();
                                                  });
                                              getData();

                                              setState(() {});
                                            } else {
                                              Get.defaultDialog(
                                                  title: "Alert",
                                                  textCancel: "Ok",
                                                  middleText:
                                                      "Send Requiest Failed Please Contact To Admin");
                                            }
                                          });
                                        } else {
                                          Get.defaultDialog(
                                              title: "Amount", middleText: msg);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10),
                        (widget.requestType == "add_money")
                            ? TextButton(
                                onPressed: () {
                                  Get.to(() => AddPointHistory());
                                },
                                child: Text(
                                  "Add History >",
                                  style: TextStyle(color: myPrimaryColor),
                                ))
                            : ElevatedButton(
                                onPressed: () {
                                  Get.to(() => WithdrawPointHistory());
                                },
                                child: Text(
                                  "Withdrawal History",
                                  style: TextStyle(color: myWhite),
                                )),
                        SizedBox(width: 10),
                        Text(
                          "Help",
                          style: TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchURLWhatsApp();
                          },
                          child: Icon(FontAwesomeIcons.whatsapp,
                              color: Colors.black),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            primary: myWhite, // <-- Button color
                            onPrimary: Colors.red, // <-- Splash color
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchURLPhone();
                          },
                          child: Icon(Icons.phone, color: Colors.black),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5),
                            primary: Color.fromARGB(
                                255, 255, 255, 255), // <-- Button color
                            onPrimary: Colors.red, // <-- Splash color
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: rules.length,
                            itemBuilder: (_, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            rules[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
