// To parse this JSON data, do
//
//     final userCreateModel = userCreateModelFromJson(jsonString);

import 'dart:convert';

UserCreateModel userCreateModelFromJson(String str) => UserCreateModel.fromJson(json.decode(str));

String userCreateModelToJson(UserCreateModel data) => json.encode(data.toJson());

class UserCreateModel {
    UserCreateModel({
        this.status,
        this.data,
    });

    bool? status;
    Data? data;

    factory UserCreateModel.fromJson(Map<String, dynamic> json) => UserCreateModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Data({
        this.userId,
        this.status,
        this.play,
        this.usrname,
        this.phone,
        this.notice1,
        this.pnotice,
        this.password,
        this.userType,
        this.phonepe,
        this.paytm,
        this.gpay,
        this.bankName,
        this.accountNumber,
        this.ifsc,
        this.money,
        this.live,
    });

    String? userId;
    String? status;
    String? play;
    String? usrname;
    String? phone;
    String? notice1;
    String? pnotice;
    String? password;
    String? userType;
    String? phonepe;
    String? paytm;
    String? gpay;
    String? bankName;
    String? accountNumber;
    String? ifsc;
    String? money;
    String? live;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        status: json["status"],
        play: json["play"],
        usrname: json["usrname"],
        phone: json["phone"],
        notice1: json["notice1"],
        pnotice: json["pnotice"],
        password: json["password"],
        userType: json["user_type"],
        phonepe: json["phonepe"],
        paytm: json["paytm"],
        gpay: json["gpay"],
        bankName: json["bank_name"],
        accountNumber: json["account_number"],
        ifsc: json["ifsc"],
        money: json["money"],
        live: json["live"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "status": status,
        "play": play,
        "usrname": usrname,
        "phone": phone,
        "notice1": notice1,
        "pnotice": pnotice,
        "password": password,
        "user_type": userType,
        "phonepe": phonepe,
        "paytm": paytm,
        "gpay": gpay,
        "bank_name": bankName,
        "account_number": accountNumber,
        "ifsc": ifsc,
        "money": money,
        "live": live,
    };
}
