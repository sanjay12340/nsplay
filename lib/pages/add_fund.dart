import 'dart:convert';

import 'package:nsplay/pages/home_page.dart';
import 'package:nsplay/services/game_result_service.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:nsplay/utils/storage_constant.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:nsplay/utils/links.dart';
import '../models/rules_model.dart';
import '../models/settings_model.dart';
import '../mywidgets/balance_show_widget.dart';
import 'add_point_history.dart';
import 'package:upi_india/upi_india.dart';
import 'package:date_time_format/date_time_format.dart';

class AddFund extends StatefulWidget {
  const AddFund({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AddFundState createState() => _AddFundState();
}

class _AddFundState extends State<AddFund> {
  var callback = "".obs;
  String? u2 = "";
  var minAmount = 299.obs;
  TextEditingController? _amountController;
  GenralApiCallService? genralApiCallService;
  List<UpiApp>? apps;
  Future<UpiResponse>? _transaction;
  List<String> rules = [];
  UpiApp? app_selected;
  String txId = "";

  var box = GetStorage();
  final dateTime = DateTime.now();

  final _formState = GlobalKey<FormState>();
  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );
  GameResultService? _remoteGameResultService;
  @override
  void initState() {
    super.initState();

    genralApiCallService = GenralApiCallService();
    _amountController = TextEditingController();
    checkRozarPay();
    getAppVersion();
    getBalance();
    fetchSettings();
    getBlockUpi();
    fetchAddMoneyrules();
  }

  void getBlockUpi() {
    GenralApiCallService.blockUpi().then((blockUpiList) => {
          _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
            setState(() {
              apps = value
                  .where(
                      (app) => !blockUpiList.contains(app.name.toLowerCase()))
                  .toList();
            });
          }).catchError((e) {
            apps = [];
          })
        });
  }

  Future<void> fetchSettings() async {
    List<SettingsModel>? listSettingModel =
        await GenralApiCallService.fetchSettings('money', 'Min Withdraw');
    if (listSettingModel != null) {
      for (var element in listSettingModel) {
        minAmount.value =
            element.id == "1" ? int.parse(element.value!) : minAmount.value;
      }
    }
  }

  getBalance() async {
    _remoteGameResultService = GameResultService();
    Map map = await _remoteGameResultService!.checkBalance();
    if (map["status"]) {
      box.write("money", map["money"].toString());

      setState(() {});
      // balance.value = int.parse(box.read("money"));
    }
  }

  getAppVersion() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT `id`, `version`, `date`, `massage`, `share_link` FROM `app_version`")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      var box = GetStorage();
      box.write(StorageConstant.upi, data[0]['massage']);
      setState(() {});
    });
  }

  fetchAddMoneyrules() {
    genralApiCallService!
        .fetchGenralQueryWithRawData(
            "SELECT  `text` FROM `rules` where name='Add Money' order by id")
        .then((value) {
      print(value);
      var data = jsonDecode(value);
      if (data != null) {
        rulesFromJson(value).forEach((element) {
          rules.add(element.text!);
        });

        setState(() {});
        print(rules);
      }
    });
  }

  checkRozarPay() {
    if (box.read(StorageConstant.upi) == null) {
      Get.offAll(() => HomePage());
    } else {
      print(box.read(StorageConstant.upi));
    }
  }

  var upb = true;
  _handlePaymentSuccesss(String resCode, String txnId) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      box.write(StorageConstant.fundAmount, _amountController!.text);
      box.write(StorageConstant.fundStatus, false);
      box.write(StorageConstant.fundApp, app_selected!.name);

      updateBalance();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final UpiIndia _upiIndia = UpiIndia();

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    app_selected = app;
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: box.read(StorageConstant.upi) ?? "",
      receiverName: appname.toUpperCase(),
      transactionRefId: box.read("id") +
          "" +
          DateTimeFormat.format(dateTime, format: 'dmYhiA'),
      transactionNote: 'u',
      amount: double.parse(_amountController!.text),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  if (_amountController!.text != "") {
                    if (int.parse(_amountController!.text) > minAmount.value) {
                      _transaction = initiateTransaction(app);
                      setState(() {});
                    } else {
                      Get.defaultDialog(
                          title: "Amount",
                          middleText: "Amount Should Be $minAmount or greater");
                    }
                  } else {
                    Get.defaultDialog(
                        title: "Amount", middleText: "Please Provide Input");
                  }
                },
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status, String resCode, String txnId) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        _handlePaymentSuccesss(resCode, txnId);
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
              child: Text(
            body,
            style: value,
          )),
        ],
      ),
    );
  }

  void updateBalance() {
    GenralApiCallService.addfundRozarPay(
            _amountController!.text.toString(), app_selected!.name, txId)
        .then((value) {
      var box = GetStorage();
      callback.value = callback.value + "Please Wait Balance updating\n";
      callback.value = callback.value + "${value!}\n";
      u2 = value;

      if (value.contains('yes')) {
        box.write(StorageConstant.fundStatus, true);

        callback.value = callback.value + "Balance Must Updated\n";
        int money = int.parse(box.read("money"));
        int money2 = int.parse(_amountController!.text);
        int total = money + money2;
        box.write("money", "$total");

        callback.value =
            callback.value + "Balance Must Updated ${box.read("money")}\n";

        Get.back();
        // Get.offAll(() => HomePage());
      } else {
        callback.value = callback.value + "Else Called Balance Not Update";
        u2 = u2! +
            " value.toLowerCase().contains('yes') == ${value.toLowerCase().contains("yes")}";
        if (Get.isDialogOpen!) {
          Get.back();
        }
        Get.offAll(() => HomePage());
      }
    }).onError((error, stackTrace) {
      callback.value = callback.value +
          "Error comes in Updated Balance ${error.toString()} stackTrace : ${stackTrace.toString()}\n";
      //Get.offAll(() => HomePage());
    }).whenComplete(() {
      callback.value = callback.value + "Whene Complete State ment called\n";

      // Get.offAll(() => HomePage());
    });
    print("Callback ::::: " + callback.value);
  }

  void _launchURLWhatsApp() async => await canLaunch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi")
      ? await launch(
          "https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi")
      : throw 'Could not launch https://wa.me/${box.read(StorageConstant.adminWhatsApp)}?text=Hi';
  void _launchURLPhone() async => await canLaunch(
          "tel:${box.read(StorageConstant.adminPhone)}")
      ? await launch("tel:${box.read(StorageConstant.adminPhone)}")
      : throw 'Could not launch tel:${box.read(StorageConstant.adminPhone)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/add_money.png",
              width: 30,
              height: 30,
            ),
            Text(widget.title),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: myAccentColor),
                  onPressed: () {
                    Get.to(() => AddPointHistory());
                  },
                  child: Row(
                    children: [
                      Text("History"),
                    ],
                  )),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width * 0.9,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: myPrimaryColor,
                    borderRadius: BorderRadius.circular(7)),
                padding: EdgeInsets.symmetric(vertical: 10),
                child:
                    BalanceShowWidget(balance: box.read(StorageConstant.money)),
              ),
              SizedBox(
                height: 10,
              ),
              // Divider(
              //   thickness: 2,
              // ),
              const Text("For Add Fund Related Query's Call Or Whatsapp",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: () {
                    _launchURLWhatsApp();
                  },
                  child: Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.black,
                    size: 35,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    primary: myWhite, // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    _launchURLPhone();
                  },
                  child: Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 35,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(5),
                    primary:
                        Color.fromARGB(255, 255, 255, 255), // <-- Button color
                    onPrimary: Colors.red, // <-- Splash color
                  ),
                ),
              ]),
              Divider(
                thickness: 2,
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Form(
                key: _formState,
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _transaction,
                      builder: (BuildContext context,
                          AsyncSnapshot<UpiResponse> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                _upiErrorHandler(snapshot.error.runtimeType),
                                style: header,
                              ), // Print's text message on screen
                            );
                          }

                          // If we have data then definitely we will have UpiResponse.
                          // It cannot be null
                          UpiResponse _upiResponse = snapshot.data!;

                          // Data in UpiResponse can be null. Check before printing
                          String txnId = _upiResponse.transactionId ?? 'N/A';
                          txId = txnId;
                          String resCode = _upiResponse.responseCode ?? 'N/A';
                          String txnRef =
                              _upiResponse.transactionRefId ?? 'N/A';
                          String status = _upiResponse.status ?? 'N/A';
                          String approvalRef =
                              _upiResponse.approvalRefNo ?? 'N/A';
                          _checkTxnStatus(status, resCode, txnId);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                displayTransactionData('Transaction Id', txnId),
                                displayTransactionData(
                                    'Response Code', resCode),
                                displayTransactionData('Reference Id', txnRef),
                                displayTransactionData(
                                    'Status', status.toUpperCase()),
                                displayTransactionData(
                                    'Approval No', approvalRef),
                              ],
                            ),
                          );
                        } else
                          return Center(
                            child: Text(''),
                          );
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: "Amount",
                          labelText: "Amount",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(300))),
                      controller: _amountController,
                      validator: (val) {
                        if (int.parse(val!) < 0) {
                          return "Amount must be greater then 300";
                        } else {
                          return null;
                        }
                      },
                    ),
                    // ElevatedButton(onPressed: checkout, child: Text("Add Point")),

                    Container(
                      child: displayUpiApps(),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: rules.length,
                                  itemBuilder: (_, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Card(
                                            elevation: 8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                rules[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
