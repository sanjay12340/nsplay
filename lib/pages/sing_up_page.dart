import 'dart:convert';

import 'dart:math';

import 'package:nsplay/pages/sign_up_final.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SingUpPage extends StatefulWidget {
  SingUpPage({Key? key}) : super(key: key);

  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _otp = TextEditingController();

  final GameResultService logincheck = GameResultService();

  final _formKey = GlobalKey<FormState>();
  var _waiting = false.obs;
  var _alreadyNumber = false.obs;
  //  var _sendAgain = false.obs;
  var _showOTPbox = false.obs;
  var _nextOTP = false.obs;
  int random = 0;
  var _mobileNode = FocusNode();
  var _verigyOTP = FocusNode();
  int _count = 0;
  @override
  void initState() {
    super.initState();
    _mobileNode.addListener(() {
      setState(() {});
    });
    _verigyOTP.addListener(() {
      setState(() {});
    });
  }

  setOTP(String phone, int random) async {
    _waiting.value = true;
    String data = await GenralApiCallService().setOTP(phone, random);
    var d = jsonDecode(data);
    if (d['Status'] == "Success") {
      _waiting.value = false;
      _showOTPbox.value = true;
      _nextOTP.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
            ),
            Text(
              "Welcome,",
              style: TextStyle(
                  color: myBlack, fontWeight: FontWeight.bold, fontSize: 35),
            ),
            Text(
              "Let's Start Sign Up!",
              style: TextStyle(
                  color: myBlack.withOpacity(.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Spacer(
              flex: 12,
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(color: Colors.white),
                child: Obx(
                  () => Column(
                    children: [
                      (_showOTPbox.value)
                          ? TextFormField(
                              focusNode: _verigyOTP,
                              cursorColor: myPrimaryColor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: myPrimaryColor),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.sms,
                                    color: _verigyOTP.hasFocus
                                        ? myPrimaryColor
                                        : Colors.grey,
                                  ),
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(7),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Enter OTP",
                                  labelText: "OTP",
                                  labelStyle: TextStyle(
                                    color: _verigyOTP.hasFocus
                                        ? myPrimaryColor
                                        : Colors.grey,
                                  )),
                              controller: _otp,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Filed not Empity";
                                } else if (val != random.toString()) {
                                  return "Invalid OTP";
                                }
                                return null;
                              },
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  focusNode: _mobileNode,
                                  cursorColor: myPrimaryColor,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    if (val.length < 10) {
                                      _alreadyNumber.value = false;
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: myPrimaryColor),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.sms,
                                      color: _mobileNode.hasFocus
                                          ? myPrimaryColor
                                          : Colors.grey,
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Mobile Number",
                                    labelText: "Mobile Number",
                                    labelStyle: TextStyle(
                                        color: _mobileNode.hasFocus
                                            ? myPrimaryColor
                                            : Colors.grey),
                                  ),
                                  controller: _phone,
                                  validator: (val) {
                                    if (val!.length != 10) {
                                      return "Invalid Number";
                                    }
                                    return null;
                                  },
                                ),
                                Obx(() => (_alreadyNumber.value)
                                    ? Text("Aleady Exit this number")
                                    : Container())
                              ],
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      (_showOTPbox.value)
                          ? Container(
                              width: size.longestSide,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        myPrimaryColor,
                                        myPrimaryColor
                                      ])),
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_otp.text == random.toString() &&
                                          !_alreadyNumber.value) {
                                      } else {
                                        print("not validated");
                                      }
                                    } else {
                                      _count++;
                                      if (_count == 2) {
                                        Get.back();
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Verify OTP",
                                    style: TextStyle(color: myWhite),
                                  )),
                            )
                          : Container(
                              width: size.longestSide,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        myPrimaryColor,
                                        myPrimaryColor
                                      ])),
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_phone.text.length == 10) {
                                        GenralApiCallService()
                                            .fetchGenralQueryWithRawData(
                                                "select phone from user where phone='${_phone.text}'")
                                            .then((value) {
                                          var data = jsonDecode(value);
                                          if (data.length > 0)
                                            _alreadyNumber.value = true;
                                          else {
                                            _alreadyNumber.value = false;

                                            random =
                                                Random().nextInt(9999) + 1000;

                                            setOTP(_phone.text, random);
                                          }
                                        });
                                      }
                                    }
                                  },
                                  child: (_waiting.value)
                                      ? Container(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          "Send OTP",
                                          style: TextStyle(color: myWhite),
                                        )),
                            ),
                      (_showOTPbox.value)
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: myPrimaryColorDark,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: TextButton(
                                        onPressed: () {
                                          random =
                                              Random().nextInt(9999) + 1000;

                                          setOTP(_phone.text, random);
                                        },
                                        child: Text("Resend OTP",
                                            style: TextStyle(color: myWhite))),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: myPrimaryColorDark,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: TextButton(
                                        onPressed: () {
                                          _showOTPbox.value = false;
                                        },
                                        child: Text("Change Number",
                                            style: TextStyle(color: myWhite))),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: CircleAvatar(
                      backgroundColor: myPrimaryColor,
                      radius: 30,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.arrow_back_ios,
                              color: myWhite,
                            )
                          ]),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
