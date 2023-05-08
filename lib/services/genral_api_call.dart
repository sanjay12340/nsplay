import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:nsplay/models/bid_history_model.dart';
import 'package:nsplay/models/block_upis.dart';
import 'package:nsplay/models/get_transaction_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nsplay/models/settings_model.dart';

import 'package:nsplay/utils/links.dart';
import 'package:nsplay/utils/storage_constant.dart';

class GenralApiCallService {
  Future<List<BidHistoryModel?>?> fetchGenralQuery(String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        List<BidHistoryModel> l = bidHistoryModelFromJson(jsonbody);
        for (var item in l) {
          print(item.gameName);
        }
        return bidHistoryModelFromJson(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<String>> blockUpi() async {
    Map data = {
      "block_upis": "true",
      'tk': token2,
    };
    List<String> listBlockUpiString = [];
    var url = Uri.parse(main_url);
    var response = await http.Client().post(
      url,
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        List<BlockUpis> listBlockUpi = blockUpisFromJson(jsonbody);
        List<String> listBlockUpiString =
            listBlockUpi.map((e) => e.upi!.toLowerCase()).toList();
        return listBlockUpiString;
      } else {
        return listBlockUpiString;
      }
    } catch (e) {
      return listBlockUpiString;
    }
  }

  Future<List<GetTransation?>?> fetchTransactionAddAmount(
      String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        print(jsonbody);
        print("Rtuen state from fetchTransactionAddAmount");
        List<GetTransation?>? l = getTransationFromJson(jsonbody);

        return l;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> fetchGenralQueryWithRawData(String genralSQL) async {
    Map data = {
      'my_genral_query': genralSQL,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);

        return jsonbody;
      } else {
        return "no data";
      }
    } catch (e) {
      return "no data";
    }
  }

  //`w_user_id`, `name`, `r_money`, `r_type`, `r_type2`, `payment_type`, `payment_link`, `transaction`, `status`, `created_at`, `update_at`
  static Future<Map<String, dynamic>?> withdrawReuest({
    required String? name,
    required String? rMoney,
    required String? rType,
    required String? rType2,
    required String? paymentType,
    required String? paymentLink,
  }) async {
    var box = GetStorage();

    Map data = {
      'add_withdraw_request': "true",
      "name": name,
      "amount": rMoney,
      "type": rType,
      "type2": rType2,
      "payment_type": paymentType,
      "payment_link": paymentLink,
      "id": box.read(StorageConstant.id),
      'tk': token2,
    };
    print(data);

    var url = Uri.parse(main_url);
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        return jsonDecode(jsonbody);
      } else {
        return null;
      }
    } catch (e) {
      print("error Catch $e");
      return null;
    }
  }

  static Future<List<SettingsModel>?> fetchSettings(
      String type, String name) async {
    Map data = {
      'settings': "true",
      'type': type,
      "name": name,
      'tk': token2,
    };

    var url = Uri.parse(main_url);
    var response = await http.Client().post(
      url,
      body: data,
    );

    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);
        List<SettingsModel> listSettingModel = settingsModelFromJson(jsonbody);
        return listSettingModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> setOTP(String phone, int random) async {
    // Map data = {
    //       "async": true,
    //       "crossDomain": true,
    //       "url": "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" + phone + "/" + random.toString() + "/Otp lion",
    //       "method": "GET",
    //       "headers": {
    //         "content-type": "application/x-www-form-urlencoded"
    //       },
    //       "data": {}
    //     };

    var url = Uri.parse(
        "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" +
            phone +
            "/" +
            random.toString() +
            "/King Lion");
    print(
        "https://2factor.in/API/V1/d5fac988-dadf-11e9-ade6-0200cd936042/SMS/" +
            phone +
            "/" +
            random.toString() +
            "/Otp lion");
    var response = await http.Client().get(url,
        headers: {"content-type": "application/x-www-form-urlencoded"});
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;
        print(jsonbody);

        return jsonbody;
      } else {
        return "no data";
      }
    } catch (e) {
      return "no data";
    }
  }

  Future<String?> fetchGenralQueryNormal(
      String sql, String success, String failure) async {
    Map data = {
      'my_genral_query_insert_update': sql,
      'success': success,
      'failure': failure,
      'gktoken': genralToken,
      'tk': token2,
    };

    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return jsonbody;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchGenralQueryNormalWithType(
      {required String sql,
      required String success,
      required String failure,
      String? type,
      String? value}) async {
    Map data = {
      'my_genral_query_insert_update2': sql,
      'success': success,
      'failure': failure,
      'gktoken': genralToken,
      'type': type ?? "",
      'value': value ?? "",
      'tk': token2,
    };
    log(data.toString(), name: "senddata");
    var url = Uri.parse("$main_url");
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return jsonbody;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> addfundRozarPay(
      String amount, String? upiName, String? trans) async {
    var box = GetStorage();
    Map data = {
      'funduserid': box.read("id"),
      'amount': amount,
      'transaction': trans,
      'upi': upiName ?? "upi",
      'tk': token2,
    };
    print("Send data" + data.toString());
    var url = Uri.parse(main_url);
    var response = await http.Client().post(
      url,
      body: data,
    );
    print(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonbody = response.body;

        return jsonbody;
      } else {
        return "no";
      }
    } catch (e) {
      return "no";
    }
  }
}
