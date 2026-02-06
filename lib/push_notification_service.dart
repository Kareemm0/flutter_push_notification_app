import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();

    final String? token = await messaging.getToken();
    log('Token: $token');

    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
  }

  static Future<void> handelBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('Handling a background message: ${message.notification?.title ?? ""}');
  }
}
