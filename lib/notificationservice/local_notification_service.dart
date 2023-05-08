import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static List<String> _receivedMessages = [];

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final groupKey =
          'unique_group_key_${message.notification!.body}_${message.notification!.title}';
      if (_receivedMessages.contains(message.notification!.body)) {
        return;
      }
      _receivedMessages.add(message.notification!.body!);
      // code to show the notification here
      //...

      Timer(Duration(minutes: 5), () {
        _receivedMessages.clear();
      });

      final textStyle = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );
      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "pushnotificationapp", "pushnotificationappchannel",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            groupKey: groupKey,
            setAsGroupSummary: false,
            styleInformation: BigTextStyleInformation(
                "<center width='100%'><b>${message.notification!.body!}<b></center>",
                contentTitle:
                    "<center><b>${message.notification!.title!}<b></center>",
  
                htmlFormatSummaryText: true,
                htmlFormatBigText: true,
                htmlFormatContent: true,
                htmlFormatContentTitle: true,
                htmlFormatTitle: true)),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        // payload: message.data['_id'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  bool showNotification(String message) {
    if (_receivedMessages.contains(message)) {
      return true;
    }
    _receivedMessages.add(message);
    return false;
    // show the notification here
  }
}
