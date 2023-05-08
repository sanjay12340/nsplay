import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:nsplay/models/game_and_type_model.dart';
import 'package:nsplay/models/get_invite_detail_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nsplay/models/game_play_condition_model.dart';
import 'package:nsplay/models/game_result_model.dart';

import 'package:nsplay/models/game_result_model_total.dart';
import 'package:nsplay/models/user_create_model.dart';
import 'package:nsplay/pages/Login.dart';
import 'package:nsplay/pages/bid_history_page_starline.dart';
import 'package:nsplay/pages/shayari_page.dart';
import 'package:nsplay/utils/links.dart';
import 'package:nsplay/utils/storage_constant.dart';

import '../models/Game_result_model_total_starline.dart';
import '../models/bid_history_starline_model.dart';
import '../models/bid_history_with_count_model.dart';
import '../models/game_last_two_result_model.dart';
import 'package:get/get.dart';

import '../models/starline_game_time_modal.dart';
import '../models/starline_game_type.dart';
import '../models/transaction_history_with_count.dart';
import '../models/transaction_modal.dart';

class GameResultService {
  static var client = http.Client();

  static Future<List<GameResultModel>?> fetchGameResult() async {
    var url = Uri.parse("$main_url" + "$token" + "&game_result=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameResultModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<BidHistoryWithCountModel?> fetchBidHistory(
      {String? userId,
      String? date,
      String? openClose,
      String? status,
      String? gameId,
      String? gameType,
      int? limit,
      int? offset}) async {
    String uri = "$main_url" "$token" "&bid_history=yes";
    uri += "&user_id=${userId}";
    if (date != null) {
      uri += "&date=${date}";
    }
    if (status != null) {
      uri += "&status=$status";
    }
    if (openClose != null) {
      uri += "&open_close=$openClose";
    }
    if (gameId != null) {
      uri += "&game_id=$gameId";
    }
    if (gameType != null) {
      uri += "&game_type=$gameType";
    }
    if (offset != null) {
      uri += "&offset=$offset";
    }
    if (limit != null) {
      uri += "&limit=$limit";
    }
    if (kDebugMode) {
      print("Bid History :: $uri");
    }
    var url = Uri.parse(uri);
    var response = await client.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return bidHistoryWithCountModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<GameResultModelTotal?> fetchGameResultWithTime() async {
    log("$main_url" + "$token" + "&game_result_with_dt=yes",
        name: "Get Result");
    var url = Uri.parse("$main_url" + "$token" + "&game_result_with_dt=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        log(jsonbody, name: "Game Result Data");
        return gameResultModelTotalFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<GameResultModelTotalStarline?> fetchGameResultWithTimeStarLine(
      {String? gameId}) async {
    var url = Uri.parse("$main_url" +
        "$token" +
        "&game_result_with_dt_starline=yes&game_id=${gameId}");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        log(jsonbody, name: "Game Result Data");
        return gameResultModelTotalStarlineFromJson(jsonbody);
      } else {
        print("Else Called $responce");
        return null;
      }
    } catch (e) {
      log(e.toString(), name: "Catch starline result", error: true);
      return null;
    }
  }

  static Future<List<StarlineGameType>?> fetchGameStarLineGameType(
      {String? gameId}) async {
    var url = Uri.parse("$main_url" + "$token" + "&startline_game_type=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        log(jsonbody, name: "Game Result Data");
        return starlineGameTypeFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<TransactionHistoryWithCount?> fetchTransactionWithCount(
      {String? date, String? limit, String? offset}) async {
    var box = GetStorage();
    String urlString =
        "$main_url$token&transaction_history=yes&user_id=${box.read(StorageConstant.id)}";
    if (date != null) {
      urlString += "&date=$date";
    }
    if (limit != null) {
      urlString += "&limit=$limit";
    }
    if (offset != null) {
      urlString += "&offset=$offset";
    }

    if (kDebugMode) {
      print("Transaction Url :: $urlString");
    }

    var url = Uri.parse(urlString);
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;
        log(jsonbody, name: "Game Result Data2");
        return transactionHistoryWithCountFromJson(jsonbody);
      } else {
        print("Else Called:::::");
        return null;
      }
    } catch (e) {
      print("Catch  Called:::::${e}");
      return null;
    }
  }

  static Future<List<GameLastTwoResultModel>?> fetchGameLastTwoResult() async {
    var url =
        Uri.parse("$main_url" + "$token" + "&game_result_with_dt_last_two=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameLastTwoResultModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<GameAndType?> fetchGameType() async {
    var url = Uri.parse("$main_url" + "$token" + "&get_game_type=yes");
    var responce = await client.get(url);
    try {
      if (responce.statusCode == 200) {
        var jsonbody = responce.body;

        return gameAndTypeFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<GamePlayConditionModel?> checkPlayCondtion(int gameId) async {
    var url = Uri.parse("$main_url" + "$token" + "&gettimeupdate=$gameId");
    var responce = await client.get(url);

    if (responce.statusCode == 200) {
      var jsonbody = jsonDecode(responce.body);
      print(jsonbody);
      return GamePlayConditionModel(
          playstatus: jsonbody['playstatus'], playoc: jsonbody['playoc']);
    } else {
      return GamePlayConditionModel(playstatus: false);
    }
  }

  static Future<bool?> checkPlayConditionStarline({String? time}) async {
    var url = Uri.parse(
        "$main_url" + "$token" + "&gettimeupdate_starline=true&time=$time");
    var responce = await client.get(url);

    if (responce.statusCode == 200) {
      var jsonbody = jsonDecode(responce.body);
      print(jsonbody);
      return jsonbody['playstatus'];
    } else {
      return false;
    }
  }

  static Future<List<StarlineGameTime>?> getStarlineTimeList() async {
    var url = Uri.parse("$main_url" + "$token" + "&starline_time_list=true");
    var responce = await client.get(url);

    if (responce.statusCode == 200) {
      print(responce.body);
      var jsonbody = responce.body;

      return starlineGameTimeFromJson(jsonbody);
    } else {
      return null;
    }
  }

  static Future<List<StarlineBidHistoryModel>?> getStarlineBidHistory(
      {String? user_id,
      String? time = "all",
      String? date,
      String? status = "all"}) async {
    String uri = "$main_url$token&starline_bid_history=true";
    uri += "&time=$time";
    uri += "&date=$date";
    uri += "&status=$status";
    uri += "&user_id=$user_id";
    var url = Uri.parse(uri);
    print("URL ::: $uri");
    var responce = await client.get(url);

    if (responce.statusCode == 200) {
      print(responce.body);
      var jsonbody = responce.body;

      return starlineBidHistoryModelFromJson(jsonbody);
    } else {
      return null;
    }
  }

  // Future<bool> logincheck(String username, String password) async {
  //   Map data = {
  //     'appuser': username,
  //     'apppass': password,
  //     'tk': token2,
  //   };

  //   var url = Uri.parse("$main_url");
  //   var response = await client.post(
  //     url,
  //     body: data,
  //   );
  //   var json = jsonDecode(response.body);
  //   print(json);
  //   if (json["status"]) {
  //     final box = GetStorage();
  //     //`phonepe`, `paytm`, `gpay`, `bank_name`, `account_number`, `ifsc`
  //     box.write('isLogedIn', json["status"]);
  //     box.write('id', json["data"]["user_id"]);
  //     box.write('username', json["data"]["usrname"]);
  //     box.write('password', json["data"]["password"]);
  //     box.write('pnotice', json["data"]["pnotice"]);
  //     box.write('notice1', json["data"]["notice1"]);
  //     box.write('money', json["data"]["money"]);
  //     box.write('phonepe', json["data"]["phonepe"]);
  //     box.write('paytm', json["data"]["paytm"]);
  //     box.write('gpay', json["data"]["gpay"]);
  //     box.write('bank_name', json["data"]["bank_name"]);
  //     box.write('account_number', json["data"]["account_number"]);
  //     box.write('ifsc', json["data"]["ifsc"]);
  //     box.write(StorageConstant.active, json["data"]["status"] == "active");
  //     box.write(StorageConstant.play, json["data"]["play"] == "active");
  //     box.write(StorageConstant.live, json["data"]["live"] == "1");
  //   }

  //   return json["status"];
  // }

  Future<bool> logincheck2(
      String username, String password, String fmctoken) async {
    Map data = {
      'appuser': username,
      'apppass': password,
      'fmctoken': fmctoken,
      'tk': token2,
    };
    print(data);
    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    var json = jsonDecode(response.body);
    print(json);
    if (json["status"]) {
      final box = GetStorage();
      //`phonepe`, `paytm`, `gpay`, `bank_name`, `account_number`, `ifsc`
      box.write(StorageConstant.isLoggedIn, json["status"]);
      box.write(StorageConstant.id, json["data"]["user_id"]);
      box.write(StorageConstant.username, json["data"]["usrname"]);
      box.write(StorageConstant.phone, json["data"]["phone"]);
      box.write(StorageConstant.password, json["data"]["password"]);
      box.write(StorageConstant.pnotice, json["data"]["pnotice"]);
      box.write(StorageConstant.notice1, json["data"]["notice1"]);
      box.write(StorageConstant.money, json["data"]["money"]);
      box.write(StorageConstant.phonepe, json["data"]["phonepe"]);
      box.write(StorageConstant.paytm, json["data"]["paytm"]);
      box.write(StorageConstant.gpay, json["data"]["gpay"]);
      box.write(StorageConstant.bank_name, json["data"]["bank_name"]);
      box.write(StorageConstant.account_number, json["data"]["account_number"]);
      box.write(StorageConstant.ifsc, json["data"]["ifsc"]);
      box.write(StorageConstant.active, json["data"]["status"] == "active");
      box.write(StorageConstant.play, json["data"]["play"] == "active");
      box.write(StorageConstant.live, json["data"]["live"] == "1");
      box.write(
          StorageConstant.notification, json["data"]["notification"] == "1");
    }

    return json["status"];
  }

// Check Login Status

  Future<bool> createNewUser(
      String username, String password, String phone) async {
    Map data = {
      'uname': username,
      'pass': password,
      'phone': phone,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return json["status"];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<GetInviteDetail> getInviteDetail() async {
    print("Method getInviteDetail");
    final box = GetStorage();
    Map data = {
      'gamecontribution': "true",
      'userid': box.read('id'),
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );
    print(response.body);
    try {
      if (response.statusCode == 200) {
        GetInviteDetail json;
        json = getInviteDetailFromJson(response.body);
        return json;
      } else {
        GetInviteDetail json = GetInviteDetail(
            bonus: '0.00',
            todayActiveUSer: '0',
            todayContribution: '0.00',
            totalInvitedUser: '0');
        return json;
      }
    } catch (e) {
      GetInviteDetail json = GetInviteDetail(
          bonus: '0.00',
          todayActiveUSer: '0',
          todayContribution: '0.00',
          totalInvitedUser: '0');
      return json;
    }
  }

  Future<bool> createNewUserRef(
      {String? username,
      String? password,
      String? phone,
      String? ref,
      String? fmctoken}) async {
    Map data = {
      'username': username,
      'password': password,
      'phone': phone,
      "fmctoken": fmctoken ?? "no",
      'ref': ref,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await client.post(
      url,
      body: data,
    );

    print(response.body);
    try {
      if (response.statusCode == 200) {
        var box = GetStorage();

        var json = jsonDecode(response.body);
        print(json);
        UserCreateModel userCreateModel =
            userCreateModelFromJson(response.body);

        if (userCreateModel.status!) {
          box.write(StorageConstant.isLoggedIn, userCreateModel.status);

          box.write(StorageConstant.id, userCreateModel.data!.userId);
          box.write(StorageConstant.username, userCreateModel.data!.usrname);
          box.write(StorageConstant.phone, userCreateModel.data!.phone);
          box.write(StorageConstant.password, userCreateModel.data!.password);
          box.write(StorageConstant.pnotice, userCreateModel.data!.pnotice);
          box.write(StorageConstant.notice1, userCreateModel.data!.notice1);
          box.write(StorageConstant.money, userCreateModel.data!.money);
          box.write(StorageConstant.phonepe, userCreateModel.data!.phonepe);
          box.write(StorageConstant.paytm, userCreateModel.data!.paytm);
          box.write(StorageConstant.gpay, userCreateModel.data!.gpay);
          box.write(StorageConstant.bank_name, userCreateModel.data!.bankName);
          box.write(StorageConstant.account_number,
              userCreateModel.data!.accountNumber);
          box.write(StorageConstant.ifsc, userCreateModel.data!.ifsc);
          box.write(
              StorageConstant.active, userCreateModel.data!.status == "active");
          box.write(
              StorageConstant.play, userCreateModel.data!.play == "active");
          box.write(StorageConstant.live, userCreateModel.data!.live == "1");
          return true;
        } else {
          log(response.body, name: "Catch Registrer error 1");
          return false;
        }
      } else {
        log(response.body, name: "Catch Registrer error 2");
        return false;
      }
    } catch (e) {
      log(e.toString(), name: "Catch Registrer error 3");
      return false;
    }
  }

  Future<Map<String?, dynamic>> checkBalance() async {
    final box = GetStorage();
    Map data = {
      'appuserid': box.read("id"),
      'myblanace': "yes",
      'tk': token2,
    };
    log(data.toString(), name: "Blanace data");
    var url = Uri.parse(main_url);
    var response = await client.post(
      url,
      body: data,
    );
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      log(json.toString(), name: "Blanace ");
      map["status"] = true;
      map["money"] = json['money'];
      map["userstatus"] = json['userstatus'];
      if (!json['mystatus']) {
        Get.defaultDialog(
            title: "Alert",
            middleText: "Your Account is suspended",
            barrierDismissible: false,
            onConfirm: () {
              Get.back();
              box.write(StorageConstant.isLoggedIn, false);
              Get.offAll(LoginPage());
            });
      } else {
        box.write(StorageConstant.live, json['live']);
        if (!json['live']) {
          Get.defaultDialog(
              title: "Alert",
              middleText: "Your Account Chnage to view mode",
              barrierDismissible: false,
              onConfirm: () {
                Get.back();

                Get.offAll(ShayariPage());
              });
        }
      }
      return map;
    } else {
      map["status"] = false;
      return map;
    }
  }
}
