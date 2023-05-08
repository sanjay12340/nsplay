import 'dart:math';

import 'package:flutter/services.dart';
import 'package:nsplay/pages/contact_info_page_bank.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';

import '../services/genral_api_call.dart';
import 'contact_info_change_password.dart';
import 'contact_info_page.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final box = GetStorage();
  final GenralApiCallService g = GenralApiCallService();
  final btn = "Update".obs;
  final _formState = GlobalKey<FormState>();
  final _number = TextEditingController();
  var notification;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification = box.read(StorageConstant.notification);
  }

  void setNotification() {}
  Widget updateInfo(String name, String number) {
    _number.text = number;
    btn.value = "Update";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
          key: _formState,
          child: Column(
            children: [
              Container(
                child: TextFormField(
                  controller: _number,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      hintText: "Mobile Number"),
                  maxLength: 10,
                  validator: (val) {
                    if (val!.length == 10 || val.length == 0) {
                      return null;
                    } else {
                      return "Please Provide 10 digit Mobile Number";
                    }
                  },
                ),
              ),
              Container(
                width: Get.size.longestSide,
                decoration: BoxDecoration(color: myPrimaryColor),
                child: TextButton(
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        btn.value = "Please Wait.....";
                        String sql =
                            "UPDATE `user` SET `$name` = '${_number.text.toString()}'  WHERE user_id ='${box.read('id')}' ";
                        g
                            .fetchGenralQueryNormal(sql, "Update success $name",
                                "Update failure $name")
                            .then((value) {
                          if (value == "Update success $name") {
                            Get.defaultDialog(
                                title: "Update Status",
                                middleText: "Success",
                                barrierDismissible: false,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      box.write(
                                          '$name', _number.text.toString());
                                      setState(() {});
                                      Get.back();
                                      Get.back<bool>(
                                        result: true,
                                      );
                                    },
                                    child: Text("ok"),
                                  ),
                                ]);
                          } else {
                            Get.defaultDialog(
                                title: "Update Status",
                                middleText: "Failed",
                                barrierDismissible: false,
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.back<bool>(
                                            result: false, canPop: true);
                                      },
                                      child: Text("ok"))
                                ]);
                          }
                        });
                      }
                    },
                    child: Obx(() => Text(
                          "${btn.value}",
                          style: TextStyle(color: myWhite),
                        ))),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(color: myAccentColor, width: 2),
        borderRadius: BorderRadius.circular(40));
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account Detail"),
        centerTitle: true,
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/profile.png",
                width: 100,
                height: 100,
              ),
              Divider(),
              Container(
                  width: Get.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Username:- ${box.read("username")}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87),
                      ),
                      Text(
                        "Wallet :- ${box.read(StorageConstant.money)}",
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
              Divider(),

              Container(
                  width: Get.width * 0.9,
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phonepe :- ${box.read("phonepe")}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                          child: Text("Update"),
                          onPressed: () async {
                            Get.defaultDialog(
                                title: "PhonePe",
                                content:
                                    updateInfo("phonepe", box.read("phonepe")));
                          },
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: Get.width * 0.9,
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gpay :- ${box.read("gpay")}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                          child: Text("Update"),
                          onPressed: () async {
                            Get.defaultDialog(
                                title: "GPay",
                                content: updateInfo("gpay", box.read("gpay")));
                          },
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: Get.width * 0.9,
                  decoration: boxDecoration,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Paytm :- ${box.read("paytm")}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                          child: Text("Update"),
                          onPressed: () async {
                            Get.defaultDialog(
                                title: "Paytm",
                                content:
                                    updateInfo("paytm", box.read("paytm")));
                          },
                        )
                      ],
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: myAccentColor, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Bank Detail",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextButton(
                              child: Text("Update"),
                              onPressed: () async {
                                //`bank_name`, `account_number`, `ifsc`
                                bool? bol = await Get.to(() =>
                                    ContactInfoPageBank(
                                        bankname:
                                            box.read("bank_name").toString(),
                                        account: box
                                            .read("account_number")
                                            .toString(),
                                        ifsc: box.read("ifsc").toString()));
                                bol = bol ?? false;
                                if (bol == true) {
                                  setState(() {});
                                }
                              },
                            )
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        Container(
                            width: Get.width * 0.9,
                            child: Text(
                              "Bank :-  ${box.read("bank_name")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        Container(
                            width: Get.width * 0.9,
                            child: Text(
                              "A/c Detail:-  ${box.read("account_number")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        Divider(
                          color: Colors.grey.shade400,
                        ),
                        Container(
                            width: Get.width * 0.9,
                            child: Text(
                              "IFSC :-  ${box.read("ifsc")}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Notification",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Switch.adaptive(
                        value: notification,
                        onChanged: (val) {
                          String sql =
                              "UPDATE `user` SET `notification` = $val  WHERE user_id ='${box.read('id')}' ";
                          g
                              .fetchGenralQueryNormal(
                                  sql, "Update success", "Update failure")
                              .then((value) {
                            if (value == "Update success") {
                              setState(() {
                                notification = val;
                              });
                            }
                          });
                        })
                  ],
                ),
              ),
              //
              //PAssword
            ],
          ),
        ),
      ),
    );
  }
}
