import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:nsplay/pages/Login.dart';
import 'package:nsplay/pages/shayari_page.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../utils/storage_constant.dart';
import 'home_page.dart';

class SignUPFinalPage extends StatefulWidget {
  SignUPFinalPage({Key? key}) : super(key: key);

  @override
  _SignUPFinalPageState createState() => _SignUPFinalPageState();
}

class _SignUPFinalPageState extends State<SignUPFinalPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final GameResultService logincheck = GameResultService();
  double width = 200;
  var _login = "Register".obs;
  var _show = false.obs;
  var _showConfrim = false.obs;
  var _alreadyUser = false.obs;
  var _alreadyUserPhone = false.obs;
  String? deviceToken = "";
  EdgeInsets contentPadding =
      const EdgeInsets.symmetric(horizontal: 5, vertical: 2);
  var defaultGap = const SizedBox(height: 12);
  final _formKey = GlobalKey<FormState>();
  GameResultService createUSer = GameResultService();

  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  var box;

  @override
  void initState() {
    super.initState();
    box = GetStorage();
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    getToken();
  }

  getToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
    setState(() {});
  }

  gameShow() {
    if (box.read(StorageConstant.live)) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => ShayariPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          backgroundColor: myWhite,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: 2,
                ),
                Container(
                    height: size.height,
                    width: size.height,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        Center(
                          child: Lottie.asset(
                            'assets/json/reg.json',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text("Register Account",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [
                                TextFormField(
                                  focusNode: _focusNodes[0],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9a-zA-Z]"))
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: contentPadding,
                                    focusColor: myPrimaryColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: myPrimaryColor,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: _focusNodes[0].hasFocus
                                          ? myPrimaryColor
                                          : Colors.grey,
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Username",
                                    labelText: "Username",
                                  ),
                                  controller: _username,
                                  onChanged: (val) {
                                    if (val.length > 5)
                                      GenralApiCallService()
                                          .fetchGenralQueryWithRawData(
                                              "select phone from user where usrname='$val'")
                                          .then((value) {
                                        var data = jsonDecode(value);
                                        if (data.length > 0)
                                          _alreadyUser.value = true;
                                        else
                                          _alreadyUser.value = false;
                                      });
                                    else
                                      _alreadyUser.value = false;
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Filed not Empity";
                                    } else if (val.length < 6) {
                                      return "Min 6 charcter";
                                    } else
                                      return null;
                                  },
                                ),
                                Obx(() => (_alreadyUser.value)
                                    ? Text("Already have username")
                                    : Container()),
                                defaultGap,
                                TextFormField(
                                  focusNode: _focusNodes[1],
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: contentPadding,
                                    focusColor: myPrimaryColor,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: myPrimaryColor,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: _focusNodes[1].hasFocus
                                          ? myPrimaryColor
                                          : Colors.grey,
                                    ),
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintText: "Phone",
                                    labelText: "Phone",
                                  ),
                                  controller: _phone,
                                  onChanged: (val) {
                                    if (val.length == 10) {
                                      log("select phone from user where phone='$val'",
                                          name: "Phone SQL");
                                      GenralApiCallService()
                                          .fetchGenralQueryWithRawData(
                                              "select phone from user where phone='$val'")
                                          .then((value) {
                                        var data = jsonDecode(value);
                                        log(value, name: "Phone verify");
                                        if (data.length > 0) {
                                          _alreadyUserPhone.value = true;
                                        } else {
                                          _alreadyUserPhone.value = false;
                                        }
                                      });
                                    } else {
                                      _alreadyUserPhone.value = false;
                                    }
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Filed not Empity";
                                    } else if (val.length != 10) {
                                      return "10 digit Mobile number";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                Obx(() => (_alreadyUserPhone.value)
                                    ? Text("Already have Phone")
                                    : Container()),
                                defaultGap,
                                Obx(
                                  () => TextFormField(
                                    focusNode: _focusNodes[2],
                                    obscureText: _show.value,
                                    controller: _password,
                                    decoration: InputDecoration(
                                      contentPadding: contentPadding,
                                      focusColor: myPrimaryColor,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: myPrimaryColor,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: _focusNodes[2].hasFocus
                                            ? myPrimaryColor
                                            : Colors.grey,
                                      ),
                                      suffix: InkWell(
                                          onTap: () {
                                            _show.value = !_show.value;
                                          },
                                          child: Icon(_show.value
                                              ? Icons.remove_red_eye_outlined
                                              : Icons.remove_red_eye_rounded)),
                                      border: OutlineInputBorder(
                                        gapPadding: 5,
                                        borderRadius: BorderRadius.circular(7),
                                        borderSide: const BorderSide(),
                                      ),
                                      hintText: "Password",
                                      labelText: "Password",
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Filed not Empity";
                                      }
                                      if (val.length < 4) {
                                        return "Password greater then 4";
                                      } else
                                        return null;
                                    },
                                  ),
                                ),
                                defaultGap,
                                Obx(
                                  () => TextFormField(
                                    controller: _confirmPassword,
                                    obscureText: _showConfrim.value,
                                    focusNode: _focusNodes[3],
                                    decoration: InputDecoration(
                                      contentPadding: contentPadding,
                                      focusColor: myPrimaryColor,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: myPrimaryColor,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: _focusNodes[3].hasFocus
                                            ? myPrimaryColor
                                            : Colors.grey,
                                      ),
                                      suffix: InkWell(
                                          onTap: () {
                                            _showConfrim.value =
                                                !_showConfrim.value;
                                          },
                                          child: Icon(_showConfrim.value
                                              ? Icons.remove_red_eye_outlined
                                              : Icons.remove_red_eye_rounded)),
                                      border: new OutlineInputBorder(
                                        gapPadding: 5,
                                        borderRadius:
                                            new BorderRadius.circular(7),
                                        borderSide: new BorderSide(),
                                      ),
                                      hintText: "Confirm password",
                                      labelText: "Confirm password",
                                    ),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Filed not Empty";
                                      }

                                      if (val != _password.text) {
                                        return "Password not match";
                                      } else
                                        return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Obx(
                                  () => Container(
                                    width: size.longestSide,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: myPrimaryColorDark),
                                    child: TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (!_alreadyUser.value &&
                                                _username.text.length > 5 &&
                                                _password.text.length > 3 &&
                                                _phone.text.length == 10 &&
                                                _password.text ==
                                                    _confirmPassword.text) {
                                              Get.defaultDialog(
                                                title: "Register",
                                                middleText: "Please Wait...",
                                                barrierDismissible: false,
                                              );
                                              createUSer
                                                  .createNewUserRef(
                                                      username: _username.text,
                                                      password: _password.text,
                                                      phone: _phone.text,
                                                      fmctoken: deviceToken!,
                                                      ref: "")
                                                  .then((value) {
                                                print(
                                                    "Check contion ${value == true}");
                                                if (value) {
                                                  Get.back();
                                                  Get.defaultDialog(
                                                      title: "congratulations",
                                                      middleText:
                                                          "Your account is created, Thanks for join us",
                                                      barrierDismissible: false,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              gameShow();
                                                            },
                                                            child: Text("Ok"))
                                                      ]);
                                                } else {
                                                  Get.back();
                                                  Get.defaultDialog(
                                                      title: "Opps",
                                                      middleText:
                                                          "Your account is Not created Contact To Admin",
                                                      barrierDismissible: false,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Get.offAll(() =>
                                                                  LoginPage());
                                                            },
                                                            child: Text("Ok"))
                                                      ]);
                                                }
                                              });
                                            } else {
                                              Get.back();

                                              Get.defaultDialog(
                                                  title: "Sorry",
                                                  middleText:
                                                      "Your Account is not created, Please Contact Admin",
                                                  barrierDismissible: false,
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Get.offAll(() =>
                                                              LoginPage());
                                                        },
                                                        child: Text("Ok"))
                                                  ]);
                                            }
                                          }
                                        },
                                        child: Text(
                                          _login.value,
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )),
              ],
            ),
          )),
    );
  }
}
