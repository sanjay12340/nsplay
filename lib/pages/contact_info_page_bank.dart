import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ContactInfoPageBank extends StatelessWidget {
  final String? bankname;
  final String? account;
  final String? ifsc;

  ContactInfoPageBank(
      {Key? key,
      required this.bankname,
      required this.account,
      required this.ifsc})
      : super(key: key);
  final _formState = GlobalKey<FormState>();
  final _bankname = TextEditingController();
  final _account = TextEditingController();
  final _ifsc = TextEditingController();
  final GenralApiCallService g = GenralApiCallService();
  final box = GetStorage();
  final btn = "Update".obs;
  @override
  Widget build(BuildContext context) {
    _bankname.text = bankname!;
    _account.text = account!;
    _ifsc.text = ifsc!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Update "),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formState,
            child: Column(
              children: [
                Card(
                  elevation: 8,
                  color: myPrimaryColor,
                  child: Container(
                    width: Get.width * 0.9,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Update Bank Detail ",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _bankname,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "Bank Name"),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _account,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "Bank Account number"),
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: _ifsc,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        hintText: "IFSC"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: Get.size.longestSide,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [myPrimaryColor, myAccentColor])),
                  child: TextButton(
                      onPressed: () {
                        //`bank_name`, `account_number`, `ifsc`
                        if (_formState.currentState!.validate()) {
                          btn.value = "Please Wait.....";
                          String sql =
                              "UPDATE `user` SET `bank_name` = '${_bankname.text.toString()}' , account_number='${_account.text.toString()}' ,ifsc='${_ifsc.text.toString()}'    WHERE user_id ='${box.read('id')}' ";
                          g
                              .fetchGenralQueryNormal(
                                  sql,
                                  "Update success Bank Detail",
                                  "Update failure Bank Detail")
                              .then((value) {
                            if (value == "Update success Bank Detail") {
                              Get.defaultDialog(
                                  title: "Update Status",
                                  middleText: "Success",
                                  barrierDismissible: false,
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          box.write('bank_name',
                                              _bankname.text.toString());
                                          box.write('account_number',
                                              _account.text.toString());
                                          box.write(
                                              'ifsc', _ifsc.text.toString());
                                          Get.back();
                                          Get.back<bool>(
                                            result: true,
                                          );
                                        },
                                        child: Text("ok"))
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
      ),
    );
  }
}
