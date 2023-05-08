import 'package:nsplay/models/Game_result_model_total_starline.dart';
import 'package:nsplay/pages/double_pana_page_starline.dart';
import 'package:nsplay/pages/single_ank_page_starline.dart';
import 'package:nsplay/pages/single_pana_page_starline.dart';
import 'package:nsplay/pages/triple_pana_page_starline.dart';
import 'package:flutter/material.dart';

class GameTypeSelectStarline extends StatelessWidget {
  final GameResultModelStarline? gameResultModelStarline;

  const GameTypeSelectStarline({Key? key, this.gameResultModelStarline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("${gameResultModelStarline!.gameName}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        scrollDirection: Axis.vertical,
        child: Column(
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
                            builder: (context) => SingleAnkPageStarline(
                              gameResultModelStarline: gameResultModelStarline!,
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
                            builder: (context) => SinglePanaPageStarline(
                              gameResultModelStarline: gameResultModelStarline!,
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
                            builder: (context) => DoublePanaPageStarline(
                              gameResultModelStarline: gameResultModelStarline!,
                            ),
                          ),
                        );
                      },
                    ),
                    GameBox(
                      size: size,
                      gameType: "Triple Pana",
                      icon: "assets/images/p_tp.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TriplePanaPageStarline(
                              gameResultModelStarline: gameResultModelStarline!,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        width: 100 - padding!,
        height: 120 - padding!,
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
