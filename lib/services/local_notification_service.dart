import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id1",
        "basic",
        importance: Importance.max,
        priority: Priority.high,
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
