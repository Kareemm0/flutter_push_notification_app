import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  //! 1 - Setup
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  static void onTab(NotificationResponse details) {
    // log(details.id!.toString());
    // log(details.payload!.toString());

    streamController.add(details);
  }

  static Future<void> init() async {
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onTab,
      onDidReceiveBackgroundNotificationResponse: onTab,
    );
  }

  //! 2 - Basic Notification
  static void showNotification(RemoteMessage meesage) async {
    final http.Response image = await http.get(
      Uri.parse(meesage.notification?.android?.imageUrl ?? ""),
    );
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(image.bodyBytes),
          ),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(image.bodyBytes),
          ),
        );
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "channel_id",
        "channel_name",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
        playSound: true,
        sound: RawResourceAndroidNotificationSound("sound".split(".").first),
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: meesage.notification?.title,
      body: meesage.notification?.body,
      notificationDetails: details,
    );
  }
}
