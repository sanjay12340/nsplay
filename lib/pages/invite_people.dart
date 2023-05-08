import 'package:nsplay/models/get_invite_detail_model.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class InvitePage extends StatefulWidget {
  InvitePage({Key? key}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  var todayContribution = "0.00".obs;
  var todayActiveUSer = "0".obs;
  var totalInvitedUser = "0".obs;
  var bonus = "0.00".obs;
  GetInviteDetail? getInviteDetail;
  var box = GetStorage();
  @override
  void initState() {
    super.initState();

    getInvideDetails();
  }

  getInvideDetails() {
    GameResultService.getInviteDetail().then((value) {
      bonus.value = value.bonus!;
      todayContribution.value = value.todayContribution!;
      totalInvitedUser.value = value.totalInvitedUser!;
      todayActiveUSer.value = value.todayActiveUSer!;
    });
  }

  void _launchURL() async => await canLaunch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      ? await launch(
          "https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}")
      : throw "Could not launch https://wa.me/?text=Click on link\n ${box.read('share')} \n Type Ref Code : ${box.read('id')}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Obx(
            () => Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Bonus\n ${bonus.value}",
                          style: TextStyle(color: myWhite, fontSize: 18),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        width: Get.size.longestSide,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(30)),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: TextButton(
                            onPressed: () {
                              _launchURL();
                              // print(box.read('share'));
                            },
                            child: Text(
                              "Invite",
                              style: TextStyle(color: myBlack, fontSize: 18),
                            )),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Today Active User\n ${todayActiveUSer.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Today Contribution\n${todayContribution.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: myPrimaryColor),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "Total Invited User\n ${totalInvitedUser.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Total Contribution\n${bonus.value}",
                          style: TextStyle(color: myWhite, fontSize: 14),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
