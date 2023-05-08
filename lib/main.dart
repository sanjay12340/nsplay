import 'package:firebase_core/firebase_core.dart';
import 'package:nsplay/pages/Login.dart';
import 'package:nsplay/pages/shayari_page.dart';
import 'package:nsplay/utils/links.dart';
import 'package:nsplay/utils/mycontant.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:nsplay/utils/storage_constant.dart';
import 'notificationservice/local_notification_service.dart';
import 'pages/home_page.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'services/genral_api_call.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalNotificationService.initialize();

  await GetStorage.init();
  final box = GetStorage();
  box.writeIfNull(StorageConstant.isLoggedIn, false);
  box.writeIfNull(StorageConstant.live, false);
  box.writeIfNull(StorageConstant.upi, 'no');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  GenralApiCallService? genralApiCallService;
  var box = GetStorage();
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
  }

  Widget gameShow() {
    if (box.read(StorageConstant.isLoggedIn)) {
      return (box.read(StorageConstant.live)) ? HomePage() : ShayariPage();
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(primaryColor: myPrimaryColor);
    return GetMaterialApp(
      title: appname,
      theme: ThemeData.light().copyWith(
          colorScheme: theme.colorScheme
              .copyWith(secondary: myAccentColor, primary: myPrimaryColorDark),
          buttonTheme: ButtonThemeData(
              buttonColor: myPrimaryColorDark,
              textTheme: ButtonTextTheme.primary)),
      home: gameShow(),
    );
  }
}
