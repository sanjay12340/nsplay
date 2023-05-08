import 'package:nsplay/pages/full_sangam_page.dart';
import 'package:nsplay/pages/half_sangam.dart';
import 'package:nsplay/pages/bet_all_game_page.dart';
import 'package:nsplay/pages/jodi_page1.dart';
import 'package:nsplay/pages/motar_dp.dart';
import 'package:nsplay/pages/motar_jodi_family.dart';
import 'package:nsplay/pages/motar_pana_family.dart';
import 'package:nsplay/pages/motar_sp.dart';
import 'package:nsplay/pages/motar_sp_dp_tp.dart';
import 'package:nsplay/pages/motor_cycle_patti.dart';
import 'package:nsplay/pages/quick_cross_page.dart';
import 'package:nsplay/pages/single_ank_page.dart';
import 'package:nsplay/pages/single_pana_page.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:nsplay/models/game_result_model.dart';
import 'package:get/get.dart';

import 'double_pana_page.dart';
import 'jodi_red_page.dart';
import 'triple_pana_page.dart';

class GameTypeSelect extends StatelessWidget {
  final GameResultModel? gameResultModel;
  final String? openClose;
  const GameTypeSelect({Key? key, this.gameResultModel, this.openClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print("open Close ::: $openClose");
    return Scaffold(
      appBar: AppBar(
        title: Text("${gameResultModel!.gameName}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        scrollDirection: Axis.vertical,
        child: openClose == "open"
            ? OpenGameWidget(
                size: size,
                gameResultModel: gameResultModel,
                openClose: openClose)
            : CloseGameWidget(
                size: size,
                gameResultModel: gameResultModel,
                openClose: openClose),
      ),
    );
  }
}

class OpenGameWidget extends StatelessWidget {
  const OpenGameWidget({
    super.key,
    required this.size,
    required this.gameResultModel,
    required this.openClose,
  });

  final Size size;
  final GameResultModel? gameResultModel;
  final String? openClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              children: [
                GameBox(
                  size: size,
                  gameType: "Single\nAnk",
                  icon: "assets/images/p_sa.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleAnkPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Jodi",
                  icon: "assets/images/p_j.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " JODI ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JodiPage(
                            gameResultModel: gameResultModel!,
                          ),
                        ),
                      );
                    }
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Single Pana",
                  icon: "assets/images/p_sp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SinglePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Double Pana",
                  icon: "assets/images/p_dp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoublePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Tripal Pana",
                  icon: "assets/images/p_tp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TriplePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Half Sanagam",
                  icon: "assets/images/p_hs.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " HALFSANGAM ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HalfSangam(
                                    gameResultModel: gameResultModel!,
                                  )));
                    }
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Full sangam",
                  icon: "assets/images/p_fs.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " FULLSANGAM ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullSangamPage(
                                  gameResultModel: gameResultModel)));
                    }
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "SP MOTOR",
                  icon: "assets/images/p_spm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SPMotor(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "DP Motor",
                  icon: "assets/images/p_dpm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DPMotor(
                                  gameResultModel: gameResultModel,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "SP DP TP MOTOR",
                  icon: "assets/images/p_sdtm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SPDPTPMotor(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Jodi Family",
                  icon: "assets/images/p_jf.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " JODI ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JodiFamily(
                                  gameResultModel: gameResultModel)));
                    }
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Pana Family",
                  icon: "assets/images/p_pf.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PanaFamily(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Cycle Family",
                  icon: "assets/images/p_cp.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CyclePatti(
                                  gameResultModel: gameResultModel,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Red Jodi",
                  icon: "assets/images/p_rj.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " JODI ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JodiRedPage(
                            gameResultModel: gameResultModel!,
                          ),
                        ),
                      );
                    }
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Quick cross",
                  icon: "assets/images/p_qc.png",
                  onTap: () {
                    if (openClose!.toLowerCase() != "open") {
                      Get.defaultDialog(
                          title: "Sorry",
                          content: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "You can't play",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                              TextSpan(
                                  text: " JODI ",
                                  style: TextStyle(
                                      color: myPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              TextSpan(
                                  text: "after open time",
                                  style:
                                      TextStyle(color: myBlack, fontSize: 14)),
                            ]),
                          ));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuickCross(
                            gameResultModel: gameResultModel!,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CloseGameWidget extends StatelessWidget {
  const CloseGameWidget({
    super.key,
    required this.size,
    required this.gameResultModel,
    required this.openClose,
  });

  final Size size;
  final GameResultModel? gameResultModel;
  final String? openClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              children: [
                GameBox(
                  size: size,
                  gameType: "Single\nAnk",
                  icon: "assets/images/p_sa.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleAnkPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Single Pana",
                  icon: "assets/images/p_sp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SinglePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Double Pana",
                  icon: "assets/images/p_dp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoublePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Tripal Pana",
                  icon: "assets/images/p_tp.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TriplePanaPage(
                          gameResultModel: gameResultModel!,
                          openClose: openClose,
                        ),
                      ),
                    );
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "SP MOTOR",
                  icon: "assets/images/p_spm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SPMotor(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "DP Motor",
                  icon: "assets/images/p_dpm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DPMotor(
                                  gameResultModel: gameResultModel,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "SP DP TP MOTOR",
                  icon: "assets/images/p_sdtm.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SPDPTPMotor(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Pana Family",
                  icon: "assets/images/p_pf.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PanaFamily(
                                  gameResultModel: gameResultModel!,
                                  openClose: openClose,
                                )));
                  },
                ),
                GameBox(
                  size: size,
                  gameType: "Cycle Family",
                  icon: "assets/images/p_cp.png",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CyclePatti(
                                  gameResultModel: gameResultModel,
                                  openClose: openClose,
                                )));
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GameBox extends StatelessWidget {
  const GameBox(
      {Key? key,
      required this.size,
      required this.gameType,
      this.icon,
      this.onTap,
      this.padding = 0})
      : super(key: key);

  final Size? size;
  final String? gameType;
  final String? icon;
  final VoidCallback? onTap;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110 - padding!,
        height: 132 - padding!,
        margin: EdgeInsets.only(top: padding!),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: AssetImage(icon!), fit: BoxFit.fill)),
      ),
    );
  }
}

class GameBox2 extends StatelessWidget {
  const GameBox2(
      {Key? key,
      required this.size,
      required this.gameType,
      this.icon,
      this.onTap,
      this.padding = 0})
      : super(key: key);

  final Size? size;
  final String? gameType;
  final String? icon;
  final VoidCallback? onTap;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120 - padding!,
        height: 120 - padding!,
        margin: EdgeInsets.only(top: padding!),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: AssetImage(icon ?? "assets/images/singleank.png"),
                fit: BoxFit.cover)),
      ),
    );
  }
}
