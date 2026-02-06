import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_push_notification_app/services/local_notification_service.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();

    final String? token = await messaging.getToken();
    log('Token: $token');

    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);

    //! Foreground Message
    handelForegroundMessage();
  }

  static Future<void> handelBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Handling a background message: ${message.notification?.title ?? ""}');
  }

  static void handelForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Show Basic Notification Using Local Notification
      LocalNotificationService.showNotification(message);
      log("Foreground Message Listener Registered");
    });
  }
}
