import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ContactInfoPage extends StatelessWidget {
  final String? name;
  final String? number;
  ContactInfoPage({Key? key, required this.name, this.number})
      : super(key: key);
  final _formState = GlobalKey<FormState>();
  final _number = TextEditingController();
  final GenralApiCallService g = GenralApiCallService();
  final box = GetStorage();
  final btn = "Update".obs;
  @override
  Widget build(BuildContext context) {
    _number.text = number!;
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
                  color: Colors.blueAccent,
                  child: Container(
                    width: Get.width * 0.9,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [myPrimaryColor, myAccentColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Text(
                      "Update $name",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
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
                              .fetchGenralQueryNormal(
                                  sql,
                                  "Update success $name",
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
      ),
    );
  }
}
