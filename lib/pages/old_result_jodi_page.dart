import 'dart:io';

import 'package:nsplay/utils/links.dart';
import 'package:flutter/material.dart';

import 'package:nsplay/models/game_result_model.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OldResultJodiPage extends StatefulWidget {
  final GameResultModel gameResultModel;
  OldResultJodiPage({
    Key? key,
    required this.gameResultModel,
  }) : super(key: key);

  @override
  _OldResultJodiPageState createState() => _OldResultJodiPageState();
}

class _OldResultJodiPageState extends State<OldResultJodiPage> {
  GenralApiCallService genralApiCallService = GenralApiCallService();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.gameResultModel.gameName} Chart"),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          initialUrl: "${baseUrl}jodichart.php?id=${widget.gameResultModel.id}",
        ));
  }
}
