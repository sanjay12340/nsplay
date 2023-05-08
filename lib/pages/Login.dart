import 'dart:convert';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nsplay/pages/home_page.dart';
import 'package:nsplay/pages/shayari_page.dart';
import 'package:nsplay/pages/sign_up_final.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/links.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nsplay/utils/storage_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'forget_password_first.dart';
import 'sing_up_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GameResultService logincheck = GameResultService();
  double width = 200;
  double redius = 8;
  var _login = "Login".obs;
  var _show = true.obs;
  var _phone = "";
  var _whatsapp = "";
  final _formKey = GlobalKey<FormState>();
  GenralApiCallService genralApiCallService = GenralApiCallService();

  var box = GetStorage();
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];
  String? deviceToken;
  @override
  void initState() {
    _focusNodes.forEach((node) {
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
    getToken();
    getContactDetail();
  }

  getToken() async {
    deviceToken = await FirebaseMessaging.instance.getToken();
  }

  gameShow() {
    if (box.read(StorageConstant.live)) {
      Get.offAll(() => HomePage());
    } else {
      Get.offAll(() => ShayariPage());
    }
  }

  getContactDetail() {
    genralApiCallService
        .fetchGenralQueryWithRawData(
            "SELECT `id`, `phone` as p, `whatsapp` as w , youtube FROM `admin_detail`")
        .then((value) {
      print(value);
      var data = jsonDecode(value);

      _phone = data[0]['p'];
      _whatsapp = data[0]['w'];
      box.write(StorageConstant.adminWhatsApp, "+91" + data[0]['w']);
      box.write(StorageConstant.adminPhone, "+91" + data[0]['p']);
    });
  }

  void _launchURLPhone() async => await canLaunch("tel:$_phone")
      ? await launch("tel:$_phone")
      : throw 'Could not launch tel:$_phone';

  void _launchURLWhatsApp() async =>
      await canLaunch("https://wa.me/+91$_whatsapp?text=Hi")
          ? await launch("https://wa.me/+91$_whatsapp?text=Hi")
          : throw 'Could not launch https://wa.me/+91$_whatsapp?text=Hi';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: myWhite,
        body: Stack(
          children: [
            Positioned(
                top: -75,
                left: -75,
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: bgColor,
                )),
            Positioned(
                bottom: -75,
                right: 75,
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: bgColor.withOpacity(0.2),
                )),
            Positioned(
                bottom: -75,
                right: -75,
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: bgColor.withOpacity(0.5),
                )),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    "assets/images/nsplay.png",
                    width: 300,
                    height: 200,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Login",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .displaySmall!
                                              .fontSize)),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("Sign in your acount",
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 16)),
                                SizedBox(
                                  height: 20,
                                ),
                                Card(
                                  elevation: 8,
                                  child: TextFormField(
                                    focusNode: _focusNodes[0],
                                    cursorColor: myBlack,
                                    decoration: InputDecoration(
                                        focusColor: myPrimaryColor,
                                        fillColor: myWhite,
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(redius),
                                          borderSide: BorderSide(
                                            color: myWhite,
                                            width: 0,
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: _focusNodes[0].hasFocus
                                              ? myPrimaryColor
                                              : Colors.grey,
                                        ),
                                        enabledBorder: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(redius),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.white),
                                        ),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(redius),
                                          borderSide: BorderSide(
                                              width: 0, color: Colors.white),
                                        ),
                                        hintText: "Username/Phone",
                                        labelStyle: TextStyle(
                                            color: _focusNodes[0].hasFocus
                                                ? myPrimaryColor
                                                : myBlack)),
                                    controller: _username,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Filed not Empity";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Obx(
                                  () => Card(
                                    elevation: 8,
                                    child: TextFormField(
                                      focusNode: _focusNodes[1],
                                      obscureText: _show.value,
                                      controller: _password,
                                      decoration: InputDecoration(
                                          fillColor: myWhite,
                                          filled: true,
                                          focusColor: myPrimaryColor,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    redius),
                                            borderSide: BorderSide(
                                              color: myWhite,
                                              width: 0,
                                            ),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: _focusNodes[1].hasFocus
                                                ? myPrimaryColor
                                                : Colors.grey,
                                          ),
                                          suffix: InkWell(
                                              onTap: () {
                                                _show.value = !_show.value;
                                              },
                                              child: Icon(_show.value
                                                  ? Icons
                                                      .remove_red_eye_outlined
                                                  : Icons
                                                      .remove_red_eye_rounded)),
                                          enabledBorder: new OutlineInputBorder(
                                            gapPadding: 5,
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    redius),
                                            borderSide: new BorderSide(
                                              color: myWhite,
                                              width: 0,
                                            ),
                                          ),
                                          hintText: "Password",
                                          labelStyle: TextStyle(
                                              color: _focusNodes[1].hasFocus
                                                  ? myPrimaryColor
                                                  : myBlack)),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Filed not Empity";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(ForgetPassword());
                                    },
                                    child: Text(
                                      "Forget Password",
                                      style: TextStyle(
                                          color: myBlack.withOpacity(.6),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: myPrimaryColor),
                                      child: Obx(
                                        () => TextButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                Get.defaultDialog(
                                                    barrierDismissible: false,
                                                    title: "Please Wait",
                                                    content: Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: const [
                                                          CircularProgressIndicator(),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Loading......")
                                                        ],
                                                      ),
                                                    ));
                                                bool _loginStatus =
                                                    await logincheck
                                                        .logincheck2(
                                                            _username
                                                                .text
                                                                .toString(),
                                                            _password.text
                                                                .toString(),
                                                            deviceToken!);
                                                if (_loginStatus) {
                                                  _login.value = "Login";
                                                  Get.back();
                                                  log(
                                                      box
                                                          .read(StorageConstant
                                                              .active)
                                                          .toString(),
                                                      name: "Active");

                                                  box.read(StorageConstant
                                                          .active)
                                                      ? gameShow()
                                                      : Get.defaultDialog(
                                                          title: "Alert",
                                                          middleText:
                                                              "Your Account is suspended please contact admin",
                                                        );
                                                } else {
                                                  Get.back();
                                                  _login.value = "Login";

                                                  Get.defaultDialog(
                                                    title: "Alert",
                                                    middleText:
                                                        "Please Check Username or Password",
                                                  );
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  _login.value,
                                                  style: TextStyle(
                                                      color: myWhite,
                                                      fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.arrow_right,
                                                  color: myWhite,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Support ::",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: myPrimaryColorDark),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {
                                  _launchURLPhone();
                                },
                                child: Icon(Icons.phone_in_talk)),
                            SizedBox(width: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                onPressed: () {
                                  _launchURLWhatsApp();
                                },
                                child: Icon(FontAwesomeIcons.whatsapp))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      width: 2, color: myPrimaryColor)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Get.to(SignUPFinalPage());
                                      },
                                      child: Text(
                                        "Create New Account",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4060564, size.height * -0.1036571);
    path_0.cubicTo(
        size.width * 0.4785767,
        size.height * -0.1700722,
        size.width * 0.5977423,
        size.height * -0.1769394,
        size.width * 0.7045031,
        size.height * -0.1927843);
    path_0.cubicTo(
        size.width * 0.8166933,
        size.height * -0.2094354,
        size.width * 0.9313252,
        size.height * -0.2303763,
        size.width * 1.038080,
        size.height * -0.1974611);
    path_0.cubicTo(
        size.width * 1.154319,
        size.height * -0.1616222,
        size.width * 1.263092,
        size.height * -0.09702980,
        size.width * 1.315503,
        size.height * -0.004400869);
    path_0.cubicTo(
        size.width * 1.367663,
        size.height * 0.08778485,
        size.width * 1.351344,
        size.height * 0.1958470,
        size.width * 1.315712,
        size.height * 0.2932192);
    path_0.cubicTo(
        size.width * 1.282933,
        size.height * 0.3827874,
        size.width * 1.210239,
        size.height * 0.4557833,
        size.width * 1.124589,
        size.height * 0.5172576);
    path_0.cubicTo(
        size.width * 1.042252,
        size.height * 0.5763586,
        size.width * 0.9471656,
        size.height * 0.6232525,
        size.width * 0.8389325,
        size.height * 0.6354343);
    path_0.cubicTo(
        size.width * 0.7304724,
        size.height * 0.6476465,
        size.width * 0.6248896,
        size.height * 0.6207929,
        size.width * 0.5245215,
        size.height * 0.5848081);
    path_0.cubicTo(
        size.width * 0.4153761,
        size.height * 0.5456818,
        size.width * 0.2788123,
        size.height * 0.5127626,
        size.width * 0.2390626,
        size.height * 0.4203864);
    path_0.cubicTo(
        size.width * 0.1993798,
        size.height * 0.3281662,
        size.width * 0.3052258,
        size.height * 0.2398939,
        size.width * 0.3353816,
        size.height * 0.1452606);
    path_0.cubicTo(
        size.width * 0.3623049,
        size.height * 0.06077273,
        size.width * 0.3351258,
        size.height * -0.03869768,
        size.width * 0.4060564,
        size.height * -0.1036571);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF9BA50).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.5594307, size.height * 0.04785818);
    path_1.cubicTo(
        size.width * 0.6319509,
        size.height * -0.01855697,
        size.width * 0.7511166,
        size.height * -0.02542394,
        size.width * 0.8578773,
        size.height * -0.04126889);
    path_1.cubicTo(
        size.width * 0.9700675,
        size.height * -0.05792020,
        size.width * 1.084699,
        size.height * -0.07886111,
        size.width * 1.191454,
        size.height * -0.04594596);
    path_1.cubicTo(
        size.width * 1.307693,
        size.height * -0.01010682,
        size.width * 1.416466,
        size.height * 0.05448535,
        size.width * 1.468877,
        size.height * 0.1471146);
    path_1.cubicTo(
        size.width * 1.521037,
        size.height * 0.2393000,
        size.width * 1.504718,
        size.height * 0.3473621,
        size.width * 1.469086,
        size.height * 0.4447343);
    path_1.cubicTo(
        size.width * 1.436307,
        size.height * 0.5343030,
        size.width * 1.363613,
        size.height * 0.6072980,
        size.width * 1.277963,
        size.height * 0.6687727);
    path_1.cubicTo(
        size.width * 1.195626,
        size.height * 0.7278737,
        size.width * 1.100540,
        size.height * 0.7747677,
        size.width * 0.9923067,
        size.height * 0.7869495);
    path_1.cubicTo(
        size.width * 0.8838466,
        size.height * 0.7991616,
        size.width * 0.7782638,
        size.height * 0.7723081,
        size.width * 0.6778957,
        size.height * 0.7363283);
    path_1.cubicTo(
        size.width * 0.5687503,
        size.height * 0.6971970,
        size.width * 0.4321865,
        size.height * 0.6642778,
        size.width * 0.3924368,
        size.height * 0.5719040);
    path_1.cubicTo(
        size.width * 0.3527540,
        size.height * 0.4796813,
        size.width * 0.4586000,
        size.height * 0.3914096,
        size.width * 0.4887558,
        size.height * 0.2967758);
    path_1.cubicTo(
        size.width * 0.5156791,
        size.height * 0.2122884,
        size.width * 0.4885000,
        size.height * 0.1128177,
        size.width * 0.5594307,
        size.height * 0.04785818);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffF4CF90).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
