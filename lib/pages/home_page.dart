import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:nsplay/controllers/game_result_controller.dart';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/models/game_result_model_total.dart';
import 'package:nsplay/pages/add_fund.dart';

import 'package:nsplay/pages/game_rate.dart';
import 'package:nsplay/pages/game_timetable.dart';
import 'package:nsplay/pages/game_type_select.dart';
import 'package:nsplay/pages/invite_people.dart';
import 'package:nsplay/pages/old_result_panel_page.dart';
import 'package:nsplay/pages/startline_home_page.dart';
import 'package:nsplay/pages/transaction_history.dart';

import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:nsplay/utils/storage_constant.dart';

import 'package:flutter/material.dart';
import 'package:nsplay/utils/links.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../models/game_last_two_result_model.dart';

import '../models/starline_game_type.dart';
import '../notificationservice/local_notification_service.dart';
import '../utils/util.dart';
import 'Login.dart';
import 'account_page.dart';
import 'add_widthdraw_point_page.dart';
import 'bid_history_page.dart';

import 'comming_soon.dart';
import 'contact_info_change_password.dart';
import 'notice_board_page.dart';
import 'notification_personal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameResultController? gameResultController;
  final double timeText = 14;
  final double tabsSize = 18;
  final double tabsSizeFont = 11;
  String? token = "";

  var _con = true.obs;
  var _notice = true.obs;
  var _marquee = "".obs;
  var _noticeText = "".obs;
  var _phone = "";
  var _youtube = "";
  var _whatsapp = "";
  var _pnotice = "".obs;
  var _cuurentIndex = 0.obs;

  Connectivity? connectvity;
  GlobalKey<RefreshIndicatorState> _refeshIndiacator = GlobalKey();
  Future<GameResultModelTotal?>? gameResultData;
  Future<List<GameLastTwoResultModel>?>? gameLastTwoResultModel;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var box = GetStorage();
  String? lis;
  GenralApiCallService? genralApiCallService;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var starlineGameTypeList = List<StarlineGameType>.empty(growable: true);
  // var balance = 0.obs;

  @override
  initState() {
    super.initState();

    genralApiCallService = GenralApiCallService();
    gameResultController = GameResultController();
    connectvity = Connectivity();

    connectvity!.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _con.value = true;
      } else {
        _con.value = false;
      }
    });

    gameResultData = getResultsWithTime();
    gameLastTwoResultModel = gameLastTwoResultModelf();
    //get Notice
    getNotice();
    getContactDetail();
    getAppVersion();
    getNumberOffNotifiaction();

    getBalance();
    getGameTypePrice();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print("New Notification");
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  Future<GameResultModelTotal?> getResultsWithTime() async {
    return await GameResultService.fetchGameResultWithTime();
  }

  Future<List<GameLastTwoResultModel>?> gameLastTwoResultModelf() async {
    return await GameResultService.fetchGameLastTwoResult();
  }

  GameResultService rgrs = GameResultService();
  getBalance() async {
    rgrs = GameResultService();
    Map map = await rgrs.checkBalance();
    if (map["status"]) {
      box.write("money", map["money"].toString());

      setState(() {});
      // balance.value = int.parse(box.read("money"));
    }
  }

  // isLogedIn id pnotice money username
  getNumberOffNotifiaction() {
    String sqlData =
        "SELECT ln.id, `notice`, `date`, `notice_to` , `view` FROM `user_notice` as un inner join live_notice as ln on ln.id=un.notice_id where user_id='${box.read(StorageConstant.id)}' and view=FALSE order by ln.id desc limit 1 ";
    print("SQLDATa::: ${sqlData}");
    genralApiCallService!.fetchGenralQueryWithRawData(sqlData).then((value) {
      log(value, name: "Notification Data");

      var data = jsonDecode(value);

      _notice.value = false;
      _pnotice.value = "0";
      print("data::: $data");
      if (data.length > 0) {
        Get.defaultDialog(
            title: "Notice",
            middleText: data[0]['notice'],
            onConfirm: () {
              genralApiCallService!.fetchGenralQueryWithRawData(
                  "UPDATE `user_notice` SET `view` ='1' WHERE user_id =${box.read('id')}");
              if (Get.isDialogOpen!) {
                Get.back();
              }
            });
      }
    });
  }

  void getGameTypePrice() {
    GameResultService.fetchGameStarLineGameType().then((value) {
      if (value != null) {
        starlineGameTypeList = value;
      }
    });
  }

  getNotice() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `notice_id`, `notice`, `notice_date` FROM `notice` ")
        .then((value) {
      var data = jsonDecode(value);
      _marquee.value = data[1]['notice'];
      _noticeText.value = data[2]['notice'];
    });
    genralApiCallService!
        .fetchGenralQueryWithRawData("SELECT `id`, `name` FROM `starline_game`")
        .then((value) {
      var data = jsonDecode(value);
      box.write(StorageConstant.starline, data[0]['name']);
      setState(() {});
    });
  }

  getContactDetail() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `id`, `phone` as p, `whatsapp` as w , youtube FROM `admin_detail`")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      _whatsapp = data[0]['w'];
      _phone = data[0]['p'];
      box.write(StorageConstant.adminWhatsApp, "+91" + data[0]['w']);
      box.write(StorageConstant.adminPhone, "+91" + data[0]['p']);
      _youtube = data[0]['youtube'] ?? "";
    });
  }

  getAppVersion() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `id`, `version`, `date`, `massage`, `share_link`,youtube,is_require,show_popup FROM `app_version`")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      var box = GetStorage();
      print("data::: $data");
      box.write("share", data[0]['share_link']);
      box.write(StorageConstant.upi, data[0]['massage']);
      if (appVersion != data[0]['version'] &&
          Util.isNullFalse(value: data[0]['show_popup'])) {
        print(
            "Not equal  appVersion $appVersion and serverversion ${data[0]['version']} ");
        Get.defaultDialog(
            title: "New Update",
            middleText: "Please update app from Play store",
            barrierDismissible: !Util.isNullFalse(value: data[0]['is_require']),
            onConfirm: () {
              _launchPlayStore(data[0]['share_link']);
            });
      } else {
        print(
            "Equal  appVersion $appVersion and serverversion ${data[0]['version']} ");
      }
    });
  }

  void goTO(Widget goTo) {
    _key.currentState!.openEndDrawer();
    Get.to(() => goTo);
  }

  void _launchPlayStore(String link) async {
    await canLaunch(link) ? await launch(link) : throw 'Could not launch $link';
  }

  void _launchURL() async => await canLaunch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      ? await launch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      : throw "Could not launch https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}";

  void _launchURLWhatsApp() async =>
      await canLaunch("https://wa.me/+91$_whatsapp?text=Hi")
          ? await launch("https://wa.me/+91$_whatsapp?text=Hi")
          : throw 'Could not launch https://wa.me/+91$_whatsapp?text=Hi';
  void _launchURLPhone() async => await canLaunch("tel:$_phone")
      ? await launch("tel:$_phone")
      : throw 'Could not launch tel:$_phone';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final timer = Icon(
      Icons.timer,
      size: 16,
      color: myAccentColor,
    );

    return Scaffold(
      key: _key,
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            child: RotatedBox(
              quarterTurns: 2,
              child: SvgPicture.asset(
                "assets/svg/menu.svg",
                color: myWhite,
              ),
            )),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appname,
                  style: GoogleFonts.poppins(
                          letterSpacing: 1.1,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)
                      .copyWith(color: myWhite)),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                constraints: BoxConstraints(minWidth: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: myPrimaryColor.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet_rounded),
                    Text(box.read(StorageConstant.money))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: myWhite,
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.account_circle,
                        color: myPrimaryColorDark,
                        size: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            box.read("username"),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            box.read(StorageConstant.phone),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CustomListMenuItem(
              name: "My Profile",
              leadingIcon: Icons.person,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(AccountPage());
              },
            ),
            CustomListMenuItem(
              name: "Bid History",
              leadingIcon: Icons.history,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(BidHistory());
              },
            ),
            CustomListMenuItem(
              name: "Transaction",
              leadingIcon: Icons.currency_exchange,
              iconColor: myPrimaryColor,
              iconSize: 30,
              onTap: () {
                goTO(TransactionHistory());
              },
            ),
            CustomListMenuItem(
              name: "Notification",
              leadingIcon: Icons.notifications_active_outlined,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(PersolNotifiaction(pnotice: _pnotice.value));
              },
            ),
            CustomListMenuItem(
              name: "Game Rate",
              leadingIcon: Icons.monetization_on,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(GameRatePage());
              },
            ),
            CustomListMenuItem(
              name: "Notice board / Rules",
              leadingIcon: Icons.perm_device_info_rounded,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(NoticeBoardPage());
              },
            ),
            CustomListMenuItem(
              name: "How To Play",
              leadingIcon: Icons.play_circle_outline,
              iconColor: myPrimaryColor,
              onTap: () {
                _launchPlayStore(_youtube);
              },
            ),
            CustomListMenuItem(
              name: "Casino Soon",
              leadingIcon: Icons.casino_outlined,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(ComingSoon());
              },
            ),
            CustomListMenuItem(
              name: "Change Password",
              leadingIcon: Icons.key,
              iconColor: myPrimaryColor,
              onTap: () {
                goTO(ContactInfoPagePassword());
              },
            ),
            CustomListMenuItem(
              name: "Share",
              leadingIcon: Icons.share,
              iconColor: myPrimaryColor,
              onTap: () {
                _key.currentState!.openEndDrawer();
                _launchURL();
              },
            ),
            CustomListMenuItem(
              name: "Logout",
              leadingIcon: Icons.logout,
              iconColor: myPrimaryColor,
              onTap: () {
                box.write(StorageConstant.isLoggedIn, false);
                Get.offAll(() {
                  return LoginPage();
                });
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: _refeshIndiacator,
        onRefresh: () {
          gameResultData = getResultsWithTime();
          getBalance();
          getNumberOffNotifiaction();
          setState(() {});
          getAppVersion();
          return Future.value(false);
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Obx(
                  () => _marquee.value.length > 0
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: MarqueeText(
                              text: TextSpan(
                                  text: _marquee.value,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red.shade900)),
                              speed: 10,
                              alwaysScroll: true),
                        )
                      : Container(),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AddFund(
                                title: "Add Money",
                              ));
                        },
                        child: Container(
                          width: Get.width * 0.45,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 15,
                                  child: Icon(
                                    Icons.currency_rupee,
                                    size: 15,
                                    color: myBlack,
                                  )),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add Money",
                                    style: TextStyle(color: myWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AddWidthdrawPage(
                                name: "Withdraw",
                                requestType: "withdraw_money",
                                addWidthdraw: "Withdrawal Money",
                                requestTypeFullName: "Withdrawal Money",
                                adminwp: _whatsapp,
                              ));
                        },
                        child: Container(
                          width: Get.width * 0.45,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 15,
                                  child: SvgPicture.asset(
                                    "assets/svg/withdraw.svg",
                                    height: 12,
                                    width: 12,
                                    color: myBlack,
                                  )),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "withdrawal Money",
                                    style: TextStyle(color: myWhite),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     Get.to(HomePageStarline(
                //       gameId: "1",
                //       starlineGameType: starlineGameTypeList,
                //       gameName:
                //           box.read(StorageConstant.starline) ?? "Starline",
                //     ));
                //   },
                //   child: Container(
                //     width: Get.width * 0.9 + 10,
                //     decoration: BoxDecoration(
                //       color: myPrimaryColorLight.withAlpha(200),
                //       borderRadius: BorderRadius.circular(40),
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.play_circle,
                //             color: myWhite,
                //             size: 40,
                //           ),
                //           SizedBox(
                //             width: 2,
                //           ),
                //           Text(
                //             box.read(StorageConstant.starline) ?? "Starline",
                //             style: TextStyle(
                //                 color: myWhite,
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 22),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => (_con.value)
                    ? FutureBuilder(
                        future: gameResultData,
                        builder: (context,
                            AsyncSnapshot<GameResultModelTotal?> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              {
                                return Container(
                                  child: Text("No Internet Connection"),
                                );
                              }

                            case ConnectionState.waiting:
                              {
                                return CircularProgressIndicator(
                                  color: myPrimaryColor,
                                );
                              }

                            default:
                              {
                                print("DEfault");
                              }
                              break;
                          }
                          if (snapshot.data != null) {
                            GameResultModelTotal? game = snapshot.data;
                            List<GameResultModel?>? l = game!.gameResultModel;

                            final d = game.dateTime;
                            String month = (d!.month < 10)
                                ? "0" + d.month.toString()
                                : d.month.toString();
                            String day = (d.day < 10)
                                ? "0" + d.day.toString()
                                : d.day.toString();
                            String cday =
                                (d.weekday == 7) ? "0" : d.weekday.toString();
                            String year = "${d.year}-$month-$day";

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: l!.map((val) {
                                  var d2 =
                                      DateTime.parse("$year ${val!.closeTime}");
                                  var d3 =
                                      DateTime.parse("$year ${val.openTime}");
                                  var diff = d2.difference(d);
                                  var diff3 = d3.difference(d);
                                  int td = diff.inHours * 60 + diff.inMinutes;
                                  int td2 =
                                      diff3.inHours * 60 + diff3.inMinutes;
                                  //String playText = "";
                                  bool playCond = true;
                                  String openClose = "";
                                  String playText = "Market is Running";
                                  bool playCond2 = true;
                                  String playText2 = "";
                                  if (!val.openStatus! || !val.closeStatus!) {
                                    if (!val.openStatus! && !val.closeStatus!) {
                                      print(
                                          "${val.gameName} Test :::: play condition close on while open close status check open ${!val.openStatus!} && close ${!val.openStatus!} ");
                                      playText = "Market is Close for today";
                                      playCond = false;
                                    } else if (!val.openStatus!) {
                                      playText2 = "Open";
                                    } else if (!val.closeStatus!) {
                                      playText2 = "Close";
                                    }
                                  }

                                  if (td > 1 &&
                                      val.days!.contains("$cday") &&
                                      val.gameOnOff == "yes") {
                                    if (td2 > 1) {
                                      openClose = "open";

                                      print(
                                          '''Account val.gameName openClose ${td2.toString()}  $year ${val.openTime} $d''');
                                      if (!val.openStatus! &&
                                          !val.closeStatus!) {
                                        playText = "Market is Close for today";
                                        playCond = false;
                                        print(
                                            '''Account val.gameName openClose ${td2.toString()}  $year ${val.openTime} $d''');
                                      }
                                    } else {
                                      openClose = "close";

                                      print('''Account 
                                          val.gameName 
                                          
                                          openClose 
                                      
                                          ${td2.toString()} 
                                          "-- $year ${val.openTime} -- $d''');
                                      if (!val.closeStatus!) {
                                        print(
                                            "${val.gameName} Test :::: play condition close on while only close status check ");
                                        playText = "Market is Close for today";
                                        playCond = false;
                                        print(
                                            '''Account val.gameName closetime ${td2.toString()}  $year ${val.openTime} $d''');
                                      }
                                    }
                                    //playText = "Market is Open";
                                  } else {
                                    print(
                                        "${val.gameName} Test :::: play condition td > 1 &&val.days!.contains(cday) &&  val.gameOnOff == yes ");
                                    playText = "Market is Close for today";
                                    playCond = false;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (playCond)
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GameTypeSelect(
                                                      gameResultModel: val,
                                                      openClose: openClose),
                                            ));
                                      else {
                                        Vibration.vibrate(
                                            pattern: [0, 500],
                                            intensities: [0, 100]);
                                        Get.snackbar("Action",
                                            "Market Closed Try Next Day",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor:
                                                Colors.green.shade50,
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 80));
                                      }
                                    },
                                    child: Stack(children: [
                                      Card(
                                        elevation: 8,
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    flex: 70,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  val.gameName!,
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                          0xFF797471)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                val.result!,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      (playCond)
                                                          ? ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      myPrimaryColorLight,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              10),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100))),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Play",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => GameTypeSelect(
                                                                          gameResultModel:
                                                                              val,
                                                                          openClose:
                                                                              openClose),
                                                                    ));
                                                              },
                                                            )
                                                          : ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5,
                                                                          horizontal:
                                                                              10),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100))),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Close",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                              onPressed: () {
                                                                Vibration.vibrate(
                                                                    pattern: [
                                                                      0,
                                                                      500
                                                                    ],
                                                                    intensities: [
                                                                      0,
                                                                      100
                                                                    ]);
                                                                Get.snackbar(
                                                                    "Action",
                                                                    "Market Closed Try Next Day",
                                                                    snackPosition:
                                                                        SnackPosition
                                                                            .BOTTOM,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green
                                                                            .shade50,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            80));
                                                              },
                                                            ),
                                                      Text(
                                                        "${val.ot} ${val.ct}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black54),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    playText,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (playCond)
                                                            ? Colors.green
                                                            : Colors.red),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                }).toList(),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    : Container(
                        child: Text("No Internet Connection"),
                      )),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: myWhite, boxShadow: [
          BoxShadow(
              color: Color.fromARGB(137, 170, 170, 170),
              blurRadius: 4.0,
              offset: Offset(0.0, 0.0))
        ]),
        width: Get.width,
        height: 50,
        padding: EdgeInsets.only(top: 2),
        child: Row(children: [
          BottomMenuItem(
            label: "My Bids",
            icon: SvgPicture.asset(
              "assets/svg/bid.svg",
              height: 20,
              width: 20,
            ),
            onTap: () {
              print("Clicked");
              Get.to(BidHistory());
            },
          ),
          BottomMenuItem(
            label: "Passbook",
            icon: SvgPicture.asset(
              "assets/svg/trans.svg",
              height: 20,
              width: 20,
            ),
            onTap: () {
              Get.to(TransactionHistory());
            },
          ),
          BottomMenuItem(
            label: "Profile",
            icon: Icon(
              FontAwesomeIcons.user,
              size: 22,
            ),
            onTap: () {
              Get.to(AccountPage());
            },
          ),
          BottomMenuItem(
            label: "Whatsapp",
            icon: Icon(
              FontAwesomeIcons.whatsapp,
              size: 25,
            ),
            onTap: () {
              _launchURLWhatsApp();
            },
          ),
          BottomMenuItem(
            label: "Call",
            icon: Icon(
              FontAwesomeIcons.phone,
              size: 22,
            ),
            onTap: () {
              _launchURLPhone();
            },
          ),
        ]),
      ),
    );
  }
}

class BottomMenuItem extends StatelessWidget {
  const BottomMenuItem({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    this.flex = 1,
    this.fontSize = 12,
  });
  final VoidCallback? onTap;
  final String? label;
  final double? fontSize;
  final Widget? icon;
  final int? flex;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex!,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon!,
            SizedBox(
              height: 5,
            ),
            Text(
              label!,
              style: TextStyle(fontSize: fontSize!),
            )
          ],
        ),
      ),
    );
  }
}

class LeftShowResult extends StatelessWidget {
  LeftShowResult({Key? key, this.name}) : super(key: key);
  final String? name;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Text(
        name ?? "",
        style: GoogleFonts.rye(color: myWhite, fontSize: 16),
      ),
    );
  }
}

class CustomListMenuItem extends StatelessWidget {
  CustomListMenuItem({
    Key? key,
    required this.name,
    required this.leadingIcon,
    required this.onTap,
    this.iconColor,
    this.iconSize = 35,
    this.leadingSpace = 20,
    this.textSize = 16,
    this.textColor = Colors.black87,
  }) : super(key: key);

  final String? name;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? textSize;
  final double? leadingSpace;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: Colors.grey.shade200))),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  leadingIcon,
                  size: iconSize,
                  color: iconColor ?? myWhite,
                ),
                SizedBox(
                  width: leadingSpace,
                ),
                Text(
                  name!,
                  style: TextStyle(
                      color: textColor,
                      fontSize: textSize,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShowNameAndResult extends StatelessWidget {
  const ShowNameAndResult({Key? key, this.name = "Name Please"})
      : super(key: key);
  final String? name;
  @override
  Widget build(BuildContext context) {
    return Text(name!,
        style: GoogleFonts.carterOne(
            letterSpacing: 1.3,
            fontSize: 16,
            color: myWhite,
            fontWeight: FontWeight.bold));
  }
}

class JodiPanelButton extends StatelessWidget {
  const JodiPanelButton({
    Key? key,
    required this.bgColor,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Color? bgColor;
  final String? name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              primary: bgColor ?? Colors.green,
              shape: StadiumBorder()),
          onPressed: onTap,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              name!,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )),
    );
  }
}

class BottomBtn extends StatelessWidget {
  const BottomBtn({
    Key? key,
    required this.tabsSize,
    required this.tabsSizeFont,
    this.function,
    this.icon,
    this.color,
  }) : super(key: key);
  final IconData? icon;
  final double tabsSize;
  final double tabsSizeFont;
  final VoidCallback? function;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: color ?? Colors.black,
          ),
        ],
      ),
    );
  }
}

class AddWidthDraw extends StatelessWidget {
  final String? name;
  final String? fullName;
  final VoidCallback? navigation;
  final Color? bgColors;
  // final IconData? iconData;
  final String imageUrl;
  const AddWidthDraw(
      {Key? key,
      this.name,
      this.fullName,
      this.navigation,
      // this.iconData,
      this.bgColors = Colors.blueAccent,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: navigation,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
                color: bgColors, borderRadius: BorderRadius.circular(8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageUrl,
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  fullName!.toUpperCase().replaceAll(" ", "\n"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }
}
